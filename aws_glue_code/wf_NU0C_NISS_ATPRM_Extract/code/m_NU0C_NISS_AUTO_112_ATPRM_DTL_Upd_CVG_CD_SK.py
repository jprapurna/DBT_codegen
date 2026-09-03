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

from pyspark.sql.functions import col, expr, lit

# Placeholder constants for environment/mapping parameters
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"

# -----------------------------------------------------------------------------
# Node: FDR_LIB_WRK_BIRP_NISS_APRM_DETL (Source)
# Pattern: staged/intermediate WRK_ source - try S3 parquet first, fallback to Glue Catalog
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting to read WRK_BIRP_NISS_APRM_DETL from S3 path first")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_brave_euclid = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
    logger.info("Successfully read WRK_BIRP_NISS_APRM_DETL from S3")
except Exception as e:
    logger.warning(
        "Failed to read WRK_BIRP_NISS_APRM_DETL from S3; falling back to Glue Catalog read: %s", str(e)
    )
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame_from_catalog(
            database=GLUE_DATABASE, table_name="FDR_LIB_WRK_BIRP_NISS_APRM_DETL"
        )
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_brave_euclid = dyf.toDF()
        logger.info("Successfully read WRK_BIRP_NISS_APRM_DETL from Glue Catalog")
    except Exception as e2:
        logger.error(
            f"Failed reading WRK_BIRP_NISS_APRM_DETL from both S3 and Glue Catalog: {e2}",
            exc_info=True,
        )
        raise

# -----------------------------------------------------------------------------
# Node: SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL (Application Source Qualifier)
# Pattern: SQL Override runs against the staged temp view of WRK_BIRP_NISS_APRM_DETL
# -----------------------------------------------------------------------------
try:
    # register the upstream staged dataframe as the temp view the override expects
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_brave_euclid.createOrReplaceTempView(
        "WRK_BIRP_NISS_APRM_DETL"
    )

    sql_query = f"""
    select distinct
        NISS_APRM_DETL_SK,
        CVG_ATTR_SK,
        CVG_CD_ATTR_SK
    from
        WRK_BIRP_NISS_APRM_DETL
    """

    logger.info(
        "Running SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL against staged temp view"
    )
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_nostalgic_lovelace = spark.sql(sql_query)
    logger.info("Successfully executed SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL")
except Exception as e:
    logger.error(
        f"Failed executing SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL: {e}",
        exc_info=True,
    )
    raise

# -----------------------------------------------------------------------------
# Node: EXP_To_generate_CVG_CD_SK (Expression)
# Pattern: project exactly NISS_APRM_DETL_SK and CVG_CD_ATTR_SK (passthrough)
# -----------------------------------------------------------------------------
try:
    logger.info("Projecting NISS_APRM_DETL_SK and CVG_CD_ATTR_SK in EXP_To_generate_CVG_CD_SK")
    df_EXP_To_generate_CVG_CD_SK_trusting_noether = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_nostalgic_lovelace.select(
        "NISS_APRM_DETL_SK",
        "CVG_CD_ATTR_SK",
    )
    logger.info("Projection complete for EXP_To_generate_CVG_CD_SK")
except Exception as e:
    logger.error(
        f"Failed projecting columns in EXP_To_generate_CVG_CD_SK: {e}", exc_info=True
    )
    raise

# -----------------------------------------------------------------------------
# Node: Upd_CVG_CD_SK (Update Strategy)
# Pattern: Derive dd_op='UPDATE', drop REJECT rows, apply load-modify-store-back to
#          s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_DETL1/ using NISS_APRM_DETL_SK
# -----------------------------------------------------------------------------
try:
    logger.info("Applying Update Strategy: deriving dd_op marker for Upd_CVG_CD_SK")
    # According to mapping plan every row is an UPDATE decision here
    df_flagged = df_EXP_To_generate_CVG_CD_SK_trusting_noether.withColumn(
        "dd_op", lit("UPDATE")
    )
    # drop REJECT rows if any (none expected)
    df_flagged = df_flagged.filter(col("dd_op") != "REJECT")
    logger.info("Derived dd_op and filtered REJECT rows for Upd_CVG_CD_SK")

    target_s3_path = f"s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_DETL1/"

    # (1) load the CURRENT full target table into a dataframe
    try:
        logger.info(
            f"Reading existing target table for load-modify-store-back from {target_s3_path}"
        )
        existing_df = spark.read.parquet(target_s3_path)
        logger.info("Successfully read existing target table for Upd_CVG_CD_SK")
    except Exception as e_read:
        # If the target does not yet exist, treat existing as empty with same schema as incoming
        logger.warning(
            f"Target path {target_s3_path} not found or unreadable; treating as empty existing table: {e_read}"
        )
        existing_df = spark.createDataFrame([], df_flagged.schema.drop("dd_op"))

    # (2) anti-join existing against changed keys to remove rows being updated/deleted
    try:
        logger.info("Computing changed keys for anti-join (NISS_APRM_DETL_SK)")
        changed_keys_df = df_flagged.select("NISS_APRM_DETL_SK").distinct()

        logger.info("Performing left_anti join to remove rows that will be updated/deleted")
        survivors_df = existing_df.join(
            changed_keys_df, on=["NISS_APRM_DETL_SK"], how="left_anti"
        )
        logger.info("Anti-join complete")
    except Exception as e_join:
        logger.error(
            f"Failed during anti-join step in Upd_CVG_CD_SK: {e_join}", exc_info=True
        )
        raise

    # (3) union survivors with rows marked INSERT/UPDATE (DELETE rows are not unioned)
    try:
        logger.info("Preparing rows to insert/update (filtering dd_op for INSERT/UPDATE)")
        rows_to_upsert = df_flagged.filter(col("dd_op").isin("INSERT", "UPDATE")).drop(
            "dd_op"
        )

        logger.info("Unioning surviving existing rows with upsert rows")
        combined_df = survivors_df.unionByName(rows_to_upsert, allowMissingColumns=True)
        logger.info("Union complete; combined dataframe ready to overwrite target")
    except Exception as e_union:
        logger.error(
            f"Failed during union step in Upd_CVG_CD_SK: {e_union}", exc_info=True
        )
        raise

    # (4) write combined dataframe back over the same target (overwrite)
    try:
        logger.info(
            f"Writing combined target dataframe back to {target_s3_path} (overwrite)"
        )
        combined_df.write.mode("overwrite").parquet(target_s3_path)
        logger.info("Successfully wrote combined dataframe to target path for Upd_CVG_CD_SK")
    except Exception as e_write:
        logger.error(
            f"Failed writing combined dataframe back to target in Upd_CVG_CD_SK: {e_write}",
            exc_info=True,
        )
        raise

    # set the node's output dataframe variable to the combined result for downstream
    df_Upd_CVG_CD_SK_admiring_bohr = combined_df
except Exception as e:
    logger.error(f"Update Strategy Upd_CVG_CD_SK failed: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 (Output)
# Pattern: write final dataframe to S3 as parquet (overwrite)
# -----------------------------------------------------------------------------
# write final FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 table as parquet to S3 (overwrite)
try:
    logger.info(
        "Writing FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite)"
    )
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_gentle_hawking = df_Upd_CVG_CD_SK_admiring_bohr
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_gentle_hawking.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_DETL1/"
    )
    logger.info("Successfully wrote FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 to S3")
except Exception as e:
    logger.error(
        f"Failed writing FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True
    )
    raise


job.commit()
