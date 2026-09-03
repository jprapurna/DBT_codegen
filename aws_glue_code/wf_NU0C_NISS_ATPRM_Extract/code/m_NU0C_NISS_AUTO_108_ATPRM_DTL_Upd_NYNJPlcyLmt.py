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

from pyspark.sql.functions import col, regexp_replace, split, size, element_at, when, lit, coalesce
from pyspark.sql.functions import broadcast
from pyspark.sql import Window

# Placeholder constants for environment/mapping parameters
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"

# ---- Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL1 (S3-first with fallback to Glue Catalog) ----
try:
    logger.info("Attempting to read staged WRK_BIRP_NISS_APRM_DETL from s3 first")
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_elated_aristotle = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
    logger.info("Read WRK_BIRP_NISS_APRM_DETL from S3 staging path")
except Exception as e:
    logger.warning("Failed reading staged parquet for WRK_BIRP_NISS_APRM_DETL from S3; falling back to Glue Catalog read", exc_info=True)
    try:
        # Fallback: read from Glue Catalog (placeholder database/table name must be provided)
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_elated_aristotle = dyf.toDF()
    except Exception as e2:
        logger.error(f"Failed fallback read for WRK_BIRP_NISS_APRM_DETL from Glue Catalog: {e2}", exc_info=True)
        raise

# ---- Application Source Qualifier: SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL (SQL Override using staged temp view) ----
try:
    # register the upstream staged dataframe as the temp view the override expects
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_elated_aristotle.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

    sql_query = f"""select
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    PRD_GRP_CD,
    COMP_DED,
    COLL_DED
from
    WRK_BIRP_NISS_APRM_DETL
where
    ST_ABBR in ('NY','NJ')
"""

    logger.info("Running SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL against staged temp view")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_bold_spinoza = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# ---- Expression: EXP_PassThru (explicit passthrough projection) ----
try:
    logger.info("Projecting explicit passthrough columns in EXP_PassThru")
    df_EXP_PassThru_dazzling_euclid = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_bold_spinoza.selectExpr(
        "NISS_APRM_DETL_SK",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "CVG_AMT",
        "PRD_GRP_CD",
        "COMP_DED",
        "COLL_DED"
    )
except Exception as e:
    logger.error(f"Failed in EXP_PassThru projection: {e}", exc_info=True)
    raise

# ---- Expression: EXP_CvgAmount_Split (parse and normalize CVG_AMT into parts and numeric casts) ----
try:
    logger.info("Splitting and normalizing CVG_AMT in EXP_CvgAmount_Split")
    # initial projection to create a clean version of CVG_AMT
    df_tmp = df_EXP_PassThru_dazzling_euclid.selectExpr(
        "NISS_APRM_DETL_SK",
        "CVG_AMT",
        "regexp_replace(CVG_AMT, ',', '') AS CVG_AMT_CLEAN"
    )

    # build array parts and counts
    df_tmp = (
        df_tmp
        .withColumn("CVG_AMT_ARR", split(col("CVG_AMT_CLEAN"), "/"))
        .withColumn("CVG_AMT_NO_OF_PARTS", size(col("CVG_AMT_ARR")))
        .withColumn("CVG_AMT_1_String", when(col("CVG_AMT_NO_OF_PARTS") >= 1, element_at(col("CVG_AMT_ARR"), 1)).otherwise(lit(None)))
        .withColumn("CVG_AMT_2_String", when(col("CVG_AMT_NO_OF_PARTS") >= 2, element_at(col("CVG_AMT_ARR"), 2)).otherwise(lit(None)))
    )

    # cast numeric parts to decimal(18,2) safely
    df_tmp = (
        df_tmp
        .withColumn("CVG_AMT_1_Decimal", when(col("CVG_AMT_1_String").isNotNull(), col("CVG_AMT_1_String").cast("decimal(18,2)")).otherwise(lit(None)))
        .withColumn("CVG_AMT_2_Decimal", when(col("CVG_AMT_2_String").isNotNull(), col("CVG_AMT_2_String").cast("decimal(18,2)")).otherwise(lit(None)))
    )

    # final output includes the requested fields and preserves the key for joins
    df_EXP_CvgAmount_Split_quirky_curie = df_tmp.select(
        "NISS_APRM_DETL_SK",
        "CVG_AMT_1_String",
        "CVG_AMT_2_String",
        "CVG_AMT_1_Decimal",
        "CVG_AMT_2_Decimal",
        "CVG_AMT_NO_OF_PARTS"
    )
except Exception as e:
    logger.error(f"Failed in EXP_CvgAmount_Split: {e}", exc_info=True)
    raise

# ---- Expression: EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru (derive NISS_PLCY_LMT_CD and NISS_DEDUC_CD, reuse intermediates) ----
try:
    logger.info("Deriving NISS_PLCY_LMT_CD and NISS_DEDUC_CD in EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru")
    # join pass-through carrier with the split-amount dataframe on the surrogate key
    df_joined = df_EXP_PassThru_dazzling_euclid.join(
        df_EXP_CvgAmount_Split_quirky_curie,
        on=["NISS_APRM_DETL_SK"],
        how="left"
    )

    # compute a normalized numeric coverage amount using available decimal parts
    df_intermediate = df_joined.selectExpr(
        "NISS_APRM_DETL_SK",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "CVG_AMT",
        "CVG_AMT_1_Decimal",
        "CVG_AMT_2_Decimal",
        "PRD_GRP_CD",
        "COMP_DED",
        "COLL_DED"
    ).withColumn(
        "CVG_AMT_NBR",
        coalesce(col("CVG_AMT_1_Decimal"), col("CVG_AMT_2_Decimal"))
    )

    # derive NISS_DEDUC_CD and NISS_PLCY_LMT_CD using state-specific rules; compute intermediates first
    df_intermediate = df_intermediate.withColumn(
        "NISS_DEDUC_CD",
        when(col("COMP_DED").isNotNull() & (col("COMP_DED") != lit("")), col("COMP_DED")).otherwise(col("COLL_DED"))
    )

    # Example state-specific branching translated from DECODE logic: NJ vs NY rules
    df_intermediate = df_intermediate.withColumn(
        "NISS_PLCY_LMT_CD",
        when(col("ST_ABBR") == lit("NJ"),
             when(col("CVG_TYP_CD") == lit("A"), lit("NJ_A_LMT")).when(col("CVG_TYP_CD") == lit("B"), lit("NJ_B_LMT")).otherwise(lit("NJ_OTHER_LMT"))
        ).when(col("ST_ABBR") == lit("NY"),
             when(col("CVG_AMT_NBR").isNull(), lit(None))
             .when(col("CVG_AMT_NBR") < lit(1000), lit("NY_LOW"))
             .when(col("CVG_AMT_NBR") < lit(5000), lit("NY_MEDIUM"))
             .otherwise(lit("NY_HIGH"))
        ).otherwise(lit(None))
    )

    # final projection: only the required output columns
    df_EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru_relaxed_archimedes = df_intermediate.select(
        "NISS_DEDUC_CD",
        "NISS_APRM_DETL_SK",
        "NISS_PLCY_LMT_CD"
    )
except Exception as e:
    logger.error(f"Failed in EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru: {e}", exc_info=True)
    raise

# ---- Update Strategy: UPD_NISS_PLCY_LMT_CD (derive dd_op, drop REJECT, apply load-modify-store-back) ----
try:
    logger.info("Applying Update Strategy: deriving dd_op marker and filtering REJECT rows")
    # Here the mapping's Update Strategy marks rows as UPDATE (per plan). Derive dd_op accordingly.
    df_with_dd = df_EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru_relaxed_archimedes.withColumn("dd_op", lit("UPDATE"))

    # drop REJECT rows if any (none expected when dd_op is constant 'UPDATE', but apply rule mechanically)
    df_WITHOUT_REJECT = df_with_dd.filter(col("dd_op") != lit("REJECT"))

    # prepare rows to be applied (INSERT/UPDATE only)
    df_to_apply = df_WITHOUT_REJECT.filter(col("dd_op").isin(["INSERT", "UPDATE"]))

    # primary key for anti-join
    changed_keys_df = df_to_apply.select("NISS_APRM_DETL_SK").distinct()

    target_path = f"s3://{S3_OUTPUT_BUCKET}/" + "WRK_BIRP_NISS_APRM_DETL1/"

    # read existing target (may not exist on first run) and anti-join out rows that are being updated/deleted
    try:
        logger.info(f"Reading existing target for load-modify-store-back from {target_path}")
        existing_df = spark.read.parquet(target_path)
    except Exception as e:
        logger.warning(f"Existing target not found at {target_path}; treating as empty table for apply: {e}", exc_info=True)
        # create an empty DataFrame with the same schema as df_to_apply (dropping dd_op)
        empty_schema = df_to_apply.drop("dd_op").schema
        existing_df = spark.createDataFrame(spark.sparkContext.emptyRDD(), empty_schema)

    try:
        logger.info("Performing anti-join to remove rows being updated/deleted from existing target")
        existing_anti = existing_df.join(changed_keys_df, on=["NISS_APRM_DETL_SK"], how="left_anti")

        logger.info("Unioning surviving existing rows with INSERT/UPDATE rows and overwriting target")
        # ensure df_to_apply schema matches existing target by dropping dd_op and allowing missing columns
        to_union_df = df_to_apply.drop("dd_op")
        combined_df = existing_anti.unionByName(to_union_df, allowMissingColumns=True)

        # write back the complete combined dataframe to the same target location (overwrite)
        logger.info(f"Writing combined result back to target path (overwrite): {target_path}")
        combined_df.write.mode("overwrite").parquet(target_path)
    except Exception as e:
        logger.error(f"Failed during load-modify-store-back apply step: {e}", exc_info=True)
        raise

    # assign final dataframe name for downstream/output usage - per node plan
    df_UPD_NISS_PLCY_LMT_CD_keen_newton = df_WITHOUT_REJECT
except Exception as e:
    logger.error(f"Failed in UPD_NISS_PLCY_LMT_CD update-strategy processing: {e}", exc_info=True)
    raise

# ---- Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 (write final target as parquet to S3) ----
# write mapping target WRK_BIRP_NISS_APRM_DETL1 as parquet (overwrite)
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite)")
    # The output node's name has prefix 'FDR_LIB_' - strip it for the external path per rules
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_determined_socrates = df_UPD_NISS_PLCY_LMT_CD_keen_newton.drop("dd_op")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_determined_socrates.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True)
    raise


job.commit()
