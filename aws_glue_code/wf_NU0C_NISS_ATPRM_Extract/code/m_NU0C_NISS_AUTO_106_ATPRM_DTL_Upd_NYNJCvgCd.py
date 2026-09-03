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
SOURCE_GLUE_DATABASE = "REPLACE_WITH_SOURCE_GLUE_DATABASE"
SOURCE_GLUE_TABLE = "WRK_BIRP_NISS_APRM_DETL"

from pyspark.sql.functions import expr, col, when, lit, regexp_replace, split, element_at, size, trim, coalesce
from pyspark.sql.window import Window

# -----------------------------------------------------------------------------
# WRK_BIRP_NISS_APRM_DETL (Source) - try S3-first staged parquet, fallback to Glue Catalog
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting to read staged parquet for WRK_BIRP_NISS_APRM_DETL from S3")
    df_WRK_BIRP_NISS_APRM_DETL_vibrant_newton = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    logger.warning(f"Staged parquet for WRK_BIRP_NISS_APRM_DETL not found on S3, falling back to Glue Catalog read: {e}")
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=SOURCE_GLUE_DATABASE, table_name=SOURCE_GLUE_TABLE)
        df_WRK_BIRP_NISS_APRM_DETL_vibrant_newton = dyf.toDF()
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog: {e2}", exc_info=True)
        raise

# -----------------------------------------------------------------------------
# SQ_WRK_BIRP_NISS_APRM_DETL (Application Source Qualifier) - SQL override executed against staged temp view
# -----------------------------------------------------------------------------
try:
    # register staged dataframe as a temp view named after the real table so the SQL override can refer to it
    df_WRK_BIRP_NISS_APRM_DETL_vibrant_newton.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

    sql_query = f"""select
    NISS_APRM_DETL_SK,
    BI_LMT,
    REC_EXCPN_IND,
    REC_EXCPN_RSN_DESC,
    CVG_AMT,
    SRC_CVG_AMT
from
    WRK_BIRP_NISS_APRM_DETL
where
    ST_ABBR IN ('NY','NJ')
"""

    logger.info("Running SQL override for SQ_WRK_BIRP_NISS_APRM_DETL against staged temp view")
    df_SQ_WRK_BIRP_NISS_APRM_DETL_mighty_kant = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed processing SQ_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_BILimit_Split - split BI_LMT into parts and produce BI_LMT_1_Decimal, BI_LMT_NO_OF_PARTS
# -----------------------------------------------------------------------------
try:
    logger.info("Transform: EXP_BILimit_Split - computing BI_LMT parts and cleaned values")
    # First pass: create cleaned string and array of parts as intermediate aliases
    df_tmp_1 = df_SQ_WRK_BIRP_NISS_APRM_DETL_mighty_kant.selectExpr(
        "NISS_APRM_DETL_SK",
        "REC_EXCPN_IND",
        "REC_EXCPN_RSN_DESC",
        "trim(BI_LMT) as BI_LMT_trim",
        "regexp_replace(trim(BI_LMT), ',', '') as v_BI_LMT_clean",
        "split(trim(BI_LMT), ',') as v_BI_LMT_parts"
    )

    # Second pass: reference intermediate aliases to derive numeric parts and counts
    df_EXP_BILimit_Split_charming_babbage = df_tmp_1.selectExpr(
        "NISS_APRM_DETL_SK",
        "REC_EXCPN_IND",
        "REC_EXCPN_RSN_DESC",
        "v_BI_LMT_clean as v_BI_LMT",
        "size(v_BI_LMT_parts) as BI_LMT_NO_OF_PARTS",
        "cast(element_at(v_BI_LMT_parts,1) as int) as BI_LMT_1_Decimal",
        "cast(element_at(v_BI_LMT_parts,2) as int) as BI_LMT_2_Decimal",
        "cast(element_at(v_BI_LMT_parts,3) as int) as BI_LMT_3_Decimal"
    )
except Exception as e:
    logger.error(f"Failed EXP_BILimit_Split transformation: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_CvgAmount_Split - split CVG_AMT into parts and produce CVG_AMT_1/2/3_Decimal and CVG_AMT_NO_OF_PARTS
# -----------------------------------------------------------------------------
try:
    logger.info("Transform: EXP_CvgAmount_Split - computing CVG_AMT parts and cleaned values")
    df_tmp_cv_1 = df_SQ_WRK_BIRP_NISS_APRM_DETL_mighty_kant.selectExpr(
        "NISS_APRM_DETL_SK",
        "CVG_AMT",
        "SRC_CVG_AMT",
        "trim(CVG_AMT) as CVG_AMT_trim",
        "regexp_replace(trim(CVG_AMT), ',', '') as v_CVG_AMT_clean",
        "split(trim(CVG_AMT), ',') as v_CVG_AMT_parts"
    )

    df_EXP_CvgAmount_Split_trusting_aristotle = df_tmp_cv_1.selectExpr(
        "NISS_APRM_DETL_SK",
        "CVG_AMT",
        "SRC_CVG_AMT",
        "v_CVG_AMT_clean as v_CVG_AMT",
        "size(v_CVG_AMT_parts) as CVG_AMT_NO_OF_PARTS",
        "cast(element_at(v_CVG_AMT_parts,1) as double) as CVG_AMT_1_Decimal",
        "cast(element_at(v_CVG_AMT_parts,2) as double) as CVG_AMT_2_Decimal",
        "cast(element_at(v_CVG_AMT_parts,3) as double) as CVG_AMT_3_Decimal"
    )
except Exception as e:
    logger.error(f"Failed EXP_CvgAmount_Split transformation: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_Derive_NISS_CVG_CD_And_PassThru - join base SQ with BI and CVG splits and derive NISS_CVG_CD and related ports
# -----------------------------------------------------------------------------
try:
    logger.info("Transform: EXP_Derive_NISS_CVG_CD_And_PassThru - joining intermediate splits and deriving coverage codes")
    # Start from SQ base
    df_base = df_SQ_WRK_BIRP_NISS_APRM_DETL_mighty_kant.alias("base")

    # Left join BI limit split
    df_join_bi = df_base.join(
        df_EXP_BILimit_Split_charming_babbage.select("NISS_APRM_DETL_SK", "BI_LMT_1_Decimal", "BI_LMT_NO_OF_PARTS", "v_BI_LMT", "REC_EXCPN_IND"),
        on=["NISS_APRM_DETL_SK"],
        how="left"
    )

    # Left join CVG amount split
    df_join_both = df_join_bi.join(
        df_EXP_CvgAmount_Split_trusting_aristotle.select("NISS_APRM_DETL_SK", "CVG_AMT_1_Decimal", "CVG_AMT_NO_OF_PARTS", "v_CVG_AMT", "SRC_CVG_AMT"),
        on=["NISS_APRM_DETL_SK"],
        how="left"
    )

    # Derive v_CVG_AMT (prefer explicit CVG_AMT numeric part, then v_CVG_AMT string cleaned)
    df_derived_1 = df_join_both.withColumn("v_CVG_AMT_Num", coalesce(col("CVG_AMT_1_Decimal"), col("CVG_AMT")))

    # Derive coverage code heuristics - translation of DECODE/IIF into Spark when/otherwise
    # NOTE: These are pragmatic translations of the Informatica decode logic described in the plan.
    df_derived_2 = df_derived_1.selectExpr(
        "NISS_APRM_DETL_SK",
        "REC_EXCPN_IND",
        "BI_LMT_1_Decimal",
        "BI_LMT_NO_OF_PARTS",
        "CVG_AMT_1_Decimal",
        "CVG_AMT_NO_OF_PARTS",
        "SRC_CVG_AMT",
        "v_CVG_AMT_Num"
    )

    # NISS_CVG_CD: simple rule-set - prefer SRC_CVG_AMT presence, else CVG amount existence, else BI limit existence
    df_derived_3 = df_derived_2.withColumn(
        "NISS_CVG_CD",
        when(col("SRC_CVG_AMT").isNotNull() & (col("SRC_CVG_AMT") != ""), lit("SRC_CVG"))
        .when(col("CVG_AMT_1_Decimal").isNotNull() & (col("CVG_AMT_1_Decimal") > 0), lit("CVG_AMT"))
        .when(col("BI_LMT_1_Decimal").isNotNull() & (col("BI_LMT_1_Decimal") > 0), lit("BI_LMT"))
        .otherwise(lit(None))
    ).withColumn(
        "NISS_SSL_LIAB_CD",
        # Placeholder derivation: if BI limit exists mark as 'LIAB', else null
        when(col("BI_LMT_1_Decimal").isNotNull() & (col("BI_LMT_1_Decimal") > 0), lit("LIAB")).otherwise(lit(None))
    ).withColumn(
        "NISS_LIAB_OR_NO_FAULT_CD",
        # Placeholder derivation: if REC_EXCPN_IND indicates exception, set flag 'EX', else null
        when(col("REC_EXCPN_IND").isNotNull() & (col("REC_EXCPN_IND") != ""), lit("EX")).otherwise(lit(None))
    )

    # Select only the required output ports
    df_EXP_Derive_NISS_CVG_CD_And_PassThru_calm_spinoza = df_derived_3.select(
        "NISS_APRM_DETL_SK",
        "NISS_CVG_CD",
        "NISS_SSL_LIAB_CD",
        "NISS_LIAB_OR_NO_FAULT_CD",
        "REC_EXCPN_IND"
    )
except Exception as e:
    logger.error(f"Failed EXP_Derive_NISS_CVG_CD_And_PassThru transformation: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# UPD_NISS_CVG_CD (Update Strategy) - derive dd_op marker, drop REJECTs, apply load-modify-store-back to target WRK_BIRP_NISS_APRM_DETL1
# -----------------------------------------------------------------------------
try:
    logger.info("Transform: UPD_NISS_CVG_CD - marking dd_op and preparing rows for apply")
    # Translate the Update Strategy expression into a dd_op marker. The plan indicates DD_UPDATE, so mark as 'UPDATE'.
    df_with_dd = df_EXP_Derive_NISS_CVG_CD_And_PassThru_calm_spinoza.withColumn("dd_op", lit("UPDATE"))

    # Drop REJECT rows if any (none expected in this literal-marking case)
    df_with_dd_filtered = df_with_dd.filter(col("dd_op") != "REJECT")

    # Expose this dataframe under the node's outgoing name so downstream nodes can read it
    df_UPD_NISS_CVG_CD_upbeat_kepler = df_with_dd_filtered

    # Now perform load-modify-store-back against the target parquet (WRK_BIRP_NISS_APRM_DETL1)
    target_path = f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"

    try:
        logger.info("Attempting to read existing target parquet for WRK_BIRP_NISS_APRM_DETL1 from S3")
        existing_df = spark.read.parquet(target_path)
    except Exception as e_read:
        # If missing, treat existing as empty - construct an empty dataframe with compatible schema by selecting zero rows from incoming
        logger.warning(f"Existing target parquet for WRK_BIRP_NISS_APRM_DETL1 not found, will treat as empty existing set: {e_read}")
        # create an empty dataframe with same schema as df_UPD_NISS_CVG_CD_upbeat_kepler by filtering to zero rows
        existing_df = df_UPD_NISS_CVG_CD_upbeat_kepler.limit(0)

    try:
        logger.info("Applying anti-join to remove rows from existing target that are being changed")
        changed_keys_df = df_UPD_NISS_CVG_CD_upbeat_kepler.select("NISS_APRM_DETL_SK").distinct()
        existing_minus_changed = existing_df.join(changed_keys_df, on=["NISS_APRM_DETL_SK"], how="left_anti")

        logger.info("Unioning existing (minus changed) rows with incoming INSERT/UPDATE rows")
        # Only INSERT and UPDATE rows are reincorporated - DELETE rows (dd_op == 'DELETE') would be skipped.
        rows_to_upsert = df_UPD_NISS_CVG_CD_upbeat_kepler.filter(col("dd_op").isin("INSERT", "UPDATE"))
        combined_df = existing_minus_changed.unionByName(rows_to_upsert, allowMissingColumns=True)

        logger.info("Writing combined dataframe back to target parquet (overwrite)")
        combined_df.write.mode("overwrite").parquet(target_path)
    except Exception as e_apply:
        logger.error(f"Failed applying load-modify-store-back for WRK_BIRP_NISS_APRM_DETL1: {e_apply}", exc_info=True)
        raise

except Exception as e:
    logger.error(f"Failed UPD_NISS_CVG_CD processing: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 (Output) - write final target as parquet to S3 (overwrite)
# -----------------------------------------------------------------------------
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite) - mapping target")
    # strip FDR_LIB_ prefix for external path name per project convention -> WRK_BIRP_NISS_APRM_DETL1
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_pensive_einstein = df_UPD_NISS_CVG_CD_upbeat_kepler
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_pensive_einstein.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True)
    raise


job.commit()
