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

from pyspark.sql.functions import col, expr, when, lit, round as spark_round
from pyspark.sql import Window

S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
GLUE_CATALOG_DATABASE = "REPLACE_WITH_GLUE_CATALOG_DATABASE"

# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL (WRK_ table - try S3-first staging read)
try:
    logger.info("Reading FDR_LIB_WRK_BIRP_NISS_APRM_DETL from S3 parquet (attempting staged read first)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_heroic_descartes = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    logger.warning("Staged S3 path for WRK_BIRP_NISS_APRM_DETL not available, falling back to Glue Catalog read: %s" % str(e))
    try:
        # Fallback to Glue Catalog - catalog database/table must be provided via placeholder
        logger.info("Falling back to Glue Catalog read for WRK_BIRP_NISS_APRM_DETL")
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_heroic_descartes = (
            glueContext.create_dynamic_frame_from_catalog(database=GLUE_CATALOG_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
            .toDF()
        )
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 (WRK_ table - try S3-first staging read)
try:
    logger.info("Reading FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 from S3 parquet (attempting staged read first)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_loving_gauss = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    logger.warning("Staged S3 path for WRK_BIRP_NISS_APRM_DETL not available for second source, falling back to Glue Catalog read: %s" % str(e))
    try:
        logger.info("Falling back to Glue Catalog read for WRK_BIRP_NISS_APRM_DETL (second source)")
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_loving_gauss = (
            glueContext.create_dynamic_frame_from_catalog(database=GLUE_CATALOG_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
            .toDF()
        )
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL (second source) from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# SQ: SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL (SQL Override - bypasses the upstream Source)
# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL (bypassed — SQL Override below reads it directly)
sql_query = f"""select
    NISS_APRM_DETL_SK,
    ROUND((CVG_EXPS_VAL * 12)) AS CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT
from
    FDR.WRK_BIRP_NISS_APRM_DETL
where
    CVG_TYP_IND = 'B'
"""
try:
    logger.info("Reading SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_modest_ramanujan from Snowflake via JDBC override query")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_modest_ramanujan = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(f"Failed reading SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_modest_ramanujan from Snowflake: {e}", exc_info=True)
    raise

# SQ: SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 (SQL Override with row_number/top-1 logic - bypasses the upstream Source)
# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 (bypassed — SQL Override below reads it directly)
sql_query = f"""select
    NISS_APRM_DETL_SK,
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT
from (
    select
        NISS_APRM_DETL_SK,
        ROUND((CVG_EXPS_VAL * 12)) AS CVG_EXPS_VAL,
        PLCY_CNTRCT_NUM,
        UNIT_NUM,
        EFF_DT,
        row_number() over (partition by PLCY_CNTRCT_NUM, UNIT_NUM order by EFF_DT desc) as rn
    from FDR.WRK_BIRP_NISS_APRM_DETL
) t
where rn = 1
"""
try:
    logger.info("Reading SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_awesome_shannon from Snowflake via JDBC override query (row_number/top-1)")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_awesome_shannon = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(f"Failed reading SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_awesome_shannon from Snowflake: {e}", exc_info=True)
    raise

# Expression: Exp_before_tgt (pure passthrough of the five columns)
try:
    logger.info("Transform Exp_before_tgt: projecting NISS_APRM_DETL_SK, CVG_EXPS_VAL, PLCY_CNTRCT_NUM, UNIT_NUM, EFF_DT")
    df_Exp_before_tgt_silly_franklin = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_modest_ramanujan.selectExpr(
        "NISS_APRM_DETL_SK",
        "CVG_EXPS_VAL",
        "PLCY_CNTRCT_NUM",
        "UNIT_NUM",
        "EFF_DT",
    )
except Exception as e:
    logger.error(f"Failed transforming Exp_before_tgt: {e}", exc_info=True)
    raise

# Expression: Exp_before_tgt1 (compute EXP_VAL_ROLLED = ROUND(CVG_EXPS_VAL * 12) and project NISS_APRM_DETL_SK, EXP_VAL_ROLLED)
try:
    logger.info("Transform Exp_before_tgt1: computing EXP_VAL_ROLLED = ROUND(CVG_EXPS_VAL * 12) and projecting NISS_APRM_DETL_SK")
    df_temp = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_awesome_shannon.selectExpr(
        "NISS_APRM_DETL_SK",
        "CVG_EXPS_VAL",
        "PLCY_CNTRCT_NUM",
        "UNIT_NUM",
        "EFF_DT",
    )
    df_Exp_before_tgt1_zen_galileo = (
        df_temp.withColumn("EXP_VAL_ROLLED", spark_round(col("CVG_EXPS_VAL") * 12))
        .select("NISS_APRM_DETL_SK", "EXP_VAL_ROLLED")
    )
except Exception as e:
    logger.error(f"Failed transforming Exp_before_tgt1: {e}", exc_info=True)
    raise

# Update Strategy: Upd_EXP_UPD (derive dd_op = 'UPDATE' and drop REJECT rows)
try:
    logger.info("Applying Update Strategy Upd_EXP_UPD: deriving dd_op marker and filtering REJECT rows")
    df_Upd_EXP_UPD_pensive_pascal = (
        df_Exp_before_tgt_silly_franklin.withColumn("dd_op", lit("UPDATE"))
        .filter(col("dd_op") != "REJECT")
    )
except Exception as e:
    logger.error(f"Failed deriving dd_op in Upd_EXP_UPD: {e}", exc_info=True)
    raise

# Update Strategy: Upd_EXP_UPD_CVG_IND_NOT_B (derive dd_op = 'UPDATE' and drop REJECT rows)
try:
    logger.info("Applying Update Strategy Upd_EXP_UPD_CVG_IND_NOT_B: deriving dd_op marker and filtering REJECT rows")
    df_Upd_EXP_UPD_CVG_IND_NOT_B_heroic_pasteur = (
        df_Exp_before_tgt1_zen_galileo.withColumn("dd_op", lit("UPDATE"))
        .filter(col("dd_op") != "REJECT")
    )
except Exception as e:
    logger.error(f"Failed deriving dd_op in Upd_EXP_UPD_CVG_IND_NOT_B: {e}", exc_info=True)
    raise

# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 (apply load-modify-store-back to S3 parquet target)
try:
    logger.info("Applying load-modify-store-back for target FDR_LIB_WRK_BIRP_NISS_APRM_DETL1")
    incoming_df = df_Upd_EXP_UPD_pensive_pascal

    # Read existing target (full table) from S3 if it exists, otherwise start with empty DF matching incoming schema
    try:
        existing_df = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_DETL1/")
        logger.info("Loaded existing FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 from S3")
    except Exception:
        logger.warning("FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 target path not found on S3; initializing empty existing dataframe")
        # create empty dataframe with incoming schema
        existing_df = spark.createDataFrame([], incoming_df.schema)

    # Identify changed keys (primary key = NISS_APRM_DETL_SK)
    try:
        changed_keys_df = incoming_df.select("NISS_APRM_DETL_SK").distinct()

        # Remove any existing rows that are being changed (anti-join on PK)
        remaining_existing_df = existing_df.join(changed_keys_df, on=["NISS_APRM_DETL_SK"], how="left_anti")

        # Keep only INSERT/UPDATE rows from incoming (drop DELETE rows if present). Here dd_op is 'UPDATE' for rows.
        incoming_to_union = incoming_df.filter(col("dd_op") != "DELETE").drop("dd_op")

        # Union the remaining existing rows with the incoming INSERT/UPDATE rows
        combined_df = remaining_existing_df.unionByName(incoming_to_union, allowMissingColumns=True)

        # write the full combined table back to the same S3 path (overwrite)
        # Note: this will read and overwrite the entire target table; this can be expensive for large tables.
        logger.info("Writing combined full table for FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite)")
        combined_df.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_DETL1/")

        # expose written df under the node's df_name for any downstream consumers
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_eager_ramanujan = combined_df
    except Exception as e:
        logger.error(f"Failed applying load-modify-store-back for FDR_LIB_WRK_BIRP_NISS_APRM_DETL1: {e}", exc_info=True)
        raise
except Exception as e:
    logger.error(f"Failed in Output node FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 overall: {e}", exc_info=True)
    raise

# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL3 (apply load-modify-store-back to S3 parquet target)
try:
    logger.info("Applying load-modify-store-back for target FDR_LIB_WRK_BIRP_NISS_APRM_DETL3")
    incoming_df = df_Upd_EXP_UPD_CVG_IND_NOT_B_heroic_pasteur

    # Read existing target (full table) from S3 if it exists, otherwise start with empty DF matching incoming schema
    try:
        existing_df = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_DETL3/")
        logger.info("Loaded existing FDR_LIB_WRK_BIRP_NISS_APRM_DETL3 from S3")
    except Exception:
        logger.warning("FDR_LIB_WRK_BIRP_NISS_APRM_DETL3 target path not found on S3; initializing empty existing dataframe")
        existing_df = spark.createDataFrame([], incoming_df.schema)

    try:
        changed_keys_df = incoming_df.select("NISS_APRM_DETL_SK").distinct()
        remaining_existing_df = existing_df.join(changed_keys_df, on=["NISS_APRM_DETL_SK"], how="left_anti")
        incoming_to_union = incoming_df.filter(col("dd_op") != "DELETE").drop("dd_op")
        combined_df = remaining_existing_df.unionByName(incoming_to_union, allowMissingColumns=True)

        logger.info("Writing combined full table for FDR_LIB_WRK_BIRP_NISS_APRM_DETL3 to S3 as parquet (overwrite)")
        combined_df.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_DETL3/")

        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL3_amazing_leibniz = combined_df
    except Exception as e:
        logger.error(f"Failed applying load-modify-store-back for FDR_LIB_WRK_BIRP_NISS_APRM_DETL3: {e}", exc_info=True)
        raise
except Exception as e:
    logger.error(f"Failed in Output node FDR_LIB_WRK_BIRP_NISS_APRM_DETL3 overall: {e}", exc_info=True)
    raise


job.commit()
