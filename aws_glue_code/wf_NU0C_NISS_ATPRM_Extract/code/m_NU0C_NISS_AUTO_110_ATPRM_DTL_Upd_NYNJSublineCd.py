import sys
from awsglue.transforms import *
from awsglue.dynamicframe import DynamicFrame
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from utils import *

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)
logger = glueContext.get_logger()

SNOWFLAKE_SECRET_NAME = "REPLACE_WITH_SNOWFLAKE_SECRET_NAME"
SNOWFLAKE_URL, SNOWFLAKE_USER, SNOWFLAKE_PASSWORD = get_snowflake_connection(SNOWFLAKE_SECRET_NAME)

S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"

# NOTE: Shortcut source is conceptually bypassed by the SQ override below. Assign a placeholder
# variable for lineage completeness (not used by the override JDBC read).
# The real data for this source is read by the SQL Override in the Application Source Qualifier.
df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_awesome_fermat = None

# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 (bypassed — SQL Override below reads it directly)
sql_query = f"""select
    NISS_APRM_DETL_SK,
    BI_LMT,
    ST_ABBR,
    ACCTNG_LOB,
    PRD_GRP_CD,
    CVG_TYP_CD
from
    FDR.WRK_BIRP_NISS_APRM_DETL
where
    ST_ABBR in ('NY','NJ')
"""

try:
    logger.info("Reading SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 from Snowflake via JDBC override query")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_focused_pasteur = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(f"Failed reading SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 from Snowflake: {e}", exc_info=True)
    raise

# EXP_BILimit_Split: parse BI_LMT into parts and numeric first part; preserve keys for join
try:
    logger.info("Transforming EXP_BILimit_Split (parse BI_LMT and derive BI_LMT parts)")
    df_EXP_BILimit_Split_brave_leibniz = (
        df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_focused_pasteur
        .selectExpr(
            "NISS_APRM_DETL_SK",
            "BI_LMT",
            "ST_ABBR",
            "ACCTNG_LOB",
            "PRD_GRP_CD",
            "CVG_TYP_CD",
            "regexp_replace(trim(BI_LMT), ',', '') as v_BI_LMT",
            "split(regexp_replace(trim(BI_LMT), ',', ''), '/') as BI_LMT_parts",
            "size(split(regexp_replace(trim(BI_LMT), ',', ''), '/')) as BI_LMT_NO_OF_PARTS",
            "cast(coalesce(split(regexp_replace(trim(BI_LMT), ',', ''), '/')[0], '0') as decimal(18,2)) as BI_LMT_1_Decimal"
        )
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_BILimit_Split: {e}", exc_info=True)
    raise

# EXP_Derive_NISS_SUBLOB_CD_And_PassThru: join BI-limit split back to SQ and derive NISS_SUBLOB_CD
from pyspark.sql.functions import col, when, lit, expr
try:
    logger.info("Transforming EXP_Derive_NISS_SUBLOB_CD_And_PassThru (derive NISS_SUBLOB_CD)")
    # join: use the SQ dataframe as primary, broadcast the smaller BI-limit-split if helpful
    from pyspark.sql import functions as F
    from pyspark.sql import DataFrame
    try:
        df_join_right = df_EXP_BILimit_Split_brave_leibniz
    except NameError:
        df_join_right = None

    # perform left join: SQ left, BI-split right
    df_joined = (
        df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_focused_pasteur.alias("sq")
        .join(df_join_right.alias("bi"), on=[col("NISS_APRM_DETL_SK").eqNullSafe(col("bi.NISS_APRM_DETL_SK"))], how="left")
    )

    # Create intermediate flags used multiple times
    df_step1 = (
        df_joined
        .withColumn("v_NJ_NO_LWST_LMT_IND", when((col("ST_ABBR") == 'NJ') & (col("BI_LMT_NO_OF_PARTS") == 1), lit('Y')).otherwise(lit('N')))
        .withColumn("v_NJ_NMD_DRVR_EXCL_IND", when((col("ST_ABBR") == 'NJ') & (col("ACCTNG_LOB").isNotNull() & (F.lower(col("ACCTNG_LOB")).like('%nmd%'))), lit('Y')).otherwise(lit('N')))
    )

    # Derive candidate sublob codes for NJ and NY using simple rule translations
    df_step2 = (
        df_step1
        .withColumn(
            "v_NISS_SUBLOB_CD_NewJersey",
            when(col("v_NJ_NO_LWST_LMT_IND") == 'Y', lit('NJ_NO_LWST'))
            .when(col("v_NJ_NMD_DRVR_EXCL_IND") == 'Y', lit('NJ_NMD_EXCL'))
            .otherwise(lit(''))
        )
        .withColumn(
            "v_NISS_SUBLOB_CD_NewYork",
            when((col("ST_ABBR") == 'NY') & (col("PRD_GRP_CD").isNotNull() & (col("PRD_GRP_CD") == 'AUTO')), lit('NY_AUTO'))
            .when((col("ST_ABBR") == 'NY') & (col("CVG_TYP_CD").isNotNull() & (col("CVG_TYP_CD") == 'LIAB')), lit('NY_LIAB'))
            .otherwise(lit(''))
        )
    )

    # Choose final value similar to DECODE-style logic: prefer NJ-derived when present else NY-derived
    df_step3 = (
        df_step2
        .withColumn(
            "v_NISS_SUBLOB_CD",
            when(col("v_NISS_SUBLOB_CD_NewJersey") != '', col("v_NISS_SUBLOB_CD_NewJersey"))
            .when(col("v_NISS_SUBLOB_CD_NewYork") != '', col("v_NISS_SUBLOB_CD_NewYork"))
            .otherwise(lit(''))
        )
        .withColumn(
            "NISS_SUBLOB_CD",
            when(col("v_NISS_SUBLOB_CD") == '', lit('?')).otherwise(col("v_NISS_SUBLOB_CD"))
        )
    )

    # Project only required output columns: NISS_APRM_DETL_SK and derived NISS_SUBLOB_CD
    df_EXP_Derive_NISS_SUBLOB_CD_And_PassThru_magical_hilbert = (
        df_step3.selectExpr("coalesce(NISS_APRM_DETL_SK, bi.NISS_APRM_DETL_SK) as NISS_APRM_DETL_SK", "NISS_SUBLOB_CD")
    )

except Exception as e:
    logger.error(f"Failed transforming EXP_Derive_NISS_SUBLOB_CD_And_PassThru: {e}", exc_info=True)
    raise

# UPD_NISS_SUBLOB_CD: Update Strategy - mark rows as UPDATE, drop REJECTs (none), load-modify-store-back to target
from pyspark.sql.functions import lit
try:
    logger.info("Applying Update Strategy UPD_NISS_SUBLOB_CD (derive dd_op marker and apply changes)")
    # derive dd_op marker: configured as DD_UPDATE for all incoming rows
    df_with_dd = df_EXP_Derive_NISS_SUBLOB_CD_And_PassThru_magical_hilbert.withColumn("dd_op", lit('UPDATE'))

    # drop REJECT rows if any (none expected)
    df_surviving = df_with_dd.filter(col("dd_op") != 'REJECT')

    # Build changed keys dataframe
    changed_keys_df = df_surviving.select("NISS_APRM_DETL_SK").distinct()

    # Load existing full target from S3 (target path derived by stripping FDR_LIB_ prefix -> WRK_BIRP_NISS_APRM_DETL1)
    try:
        logger.info("Reading existing target WRK_BIRP_NISS_APRM_DETL1 from S3 for load-modify-store-back")
        existing_df = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/")
    except Exception as e:
        logger.error(f"Failed reading existing target WRK_BIRP_NISS_APRM_DETL1 from S3: {e}", exc_info=True)
        raise

    # Anti-join to remove rows that will be updated/deleted
    existing_remaining = existing_df.join(changed_keys_df, on='NISS_APRM_DETL_SK', how='left_anti')

    # Keep only INSERT/UPDATE rows from surviving set (DELETE would be dropped). Here dd_op == 'UPDATE'.
    rows_to_upsert = df_surviving.filter(col("dd_op").isin('INSERT', 'UPDATE'))

    # Combine remaining existing rows with upsert rows
    from functools import reduce
    combined_df = existing_remaining.unionByName(rows_to_upsert.select(existing_remaining.columns).unionByName(rows_to_upsert, allowMissingColumns=True), allowMissingColumns=True)

    # Because the select/union above may be complicated when schemas differ, build a robust union:
    combined_df = existing_remaining.unionByName(rows_to_upsert, allowMissingColumns=True)

    # Write the full combined dataframe back to the same target location (overwrite)
    try:
        logger.info("Writing combined target WRK_BIRP_NISS_APRM_DETL1 back to S3 as parquet (overwrite) [Update Strategy apply]")
        combined_df.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/")
    except Exception as e:
        logger.error(f"Failed writing combined target WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True)
        raise

    # Assign the final dataframe result to the node's output df name
    df_UPD_NISS_SUBLOB_CD_eager_hilbert = combined_df

except Exception as e:
    logger.error(f"Failed in Update Strategy UPD_NISS_SUBLOB_CD: {e}", exc_info=True)
    raise

# write final mapping target as parquet to S3 (overwrite)
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite) — final mapping target")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_amazing_mendel = df_UPD_NISS_SUBLOB_CD_eager_hilbert
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_amazing_mendel.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True)
    raise


job.commit()
