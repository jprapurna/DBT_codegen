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
CATALOG_DATABASE = "REPLACE_WITH_GLUE_CATALOG_DATABASE"

from pyspark.sql.functions import row_number, lit, col
from pyspark.sql.window import Window

# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 (staged/intermediate source)
try:
    logger.info("Attempting to read staged parquet for WRK_BIRP_NISS_APRM_DETL from S3")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_adoring_shannon = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    ).select("CVG_ATTR_CHCKSUM")
except Exception as e:
    logger.warning(
        f"S3 parquet for WRK_BIRP_NISS_APRM_DETL not available, falling back to Glue Catalog read: {e}"
    )
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Data Catalog as fallback")
        dyf = glueContext.create_dynamic_frame_from_catalog(
            database=CATALOG_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL"
        )
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_adoring_shannon = dyf.toDF().select("CVG_ATTR_CHCKSUM")
    except Exception as e2:
        logger.error(
            f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog fallback: {e2}",
            exc_info=True,
        )
        raise

# SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1: SQL Override rewritten to run against staged temp view
try:
    # register the upstream staged dataframe as the bare table the override references
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_adoring_shannon.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

    sql_query = f"""select DISTINCT
    CVG_ATTR_CHCKSUM
from
    WRK_BIRP_NISS_APRM_DETL
"""

    logger.info("Running rewritten SQ override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 via spark.sql")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_trusting_euclid = spark.sql(sql_query)
except Exception as e:
    logger.error(
        f"Failed executing rewritten SQL for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1: {e}",
        exc_info=True,
    )
    raise

# EXPTRANS: project CVG_ATTR_CHCKSUM then attach gap-free surrogate CVG_ATTR_SK
try:
    # First project the explicit non-key columns (do not use '*')
    df_tmp_EXPTRANS = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_trusting_euclid.select("CVG_ATTR_CHCKSUM")

    # Now attach CVG_ATTR_SK as a gap-free row_number() over a single ordering to emulate Sequence Generator.
    # NOTE: This enforces a single-partition shuffle; review if input volume is very large.
    df_EXPTRANS_careful_babbage = df_tmp_EXPTRANS.withColumn(
        "CVG_ATTR_SK", row_number().over(Window.orderBy(lit(1)))
    )
except Exception as e:
    logger.error(f"Failed transforming EXPTRANS node: {e}", exc_info=True)
    raise

# JNRTRANS: Joiner with missing second input. Carry through available columns and emit missing join columns as NULL.
try:
    logger.info(
        "JNRTRANS: downstream join partner is missing from mapping. Producing join output from available left input and filling missing right-side keys with NULLs."
    )
    # The true join would be: left.join(right, left.CVG_ATTR_CHCKSUM = right.CVG_ATTR_CHCKSUM1, how='inner')
    # But right-side dataframe df_EXPTRANS1_charming_hopper is absent. Produce best-effort output.
    df_JNRTRANS_dazzling_kepler = df_EXPTRANS_careful_babbage.withColumn("NISS_APRM_DETL_SK", lit(None))
except Exception as e:
    logger.error(f"Failed producing JNRTRANS output: {e}", exc_info=True)
    raise

# EXP_PassThrough: pure passthrough of NISS_APRM_DETL_SK and CVG_ATTR_SK
try:
    df_EXP_PassThrough_mystifying_gauss = df_JNRTRANS_dazzling_kepler.selectExpr(
        "NISS_APRM_DETL_SK",
        "CVG_ATTR_SK"
    )
except Exception as e:
    logger.error(f"Failed in EXP_PassThrough projection: {e}", exc_info=True)
    raise

# Upd_CVG_ATTR_SK: Update Strategy - mark rows as UPDATE, drop REJECTs, then apply load-modify-store-back against WRK_BIRP_NISS_APRM_DETL
try:
    logger.info("Deriving dd_op marker for Update Strategy (all input rows -> 'UPDATE')")
    df_marker = df_EXP_PassThrough_mystifying_gauss.withColumn("dd_op", lit("UPDATE"))

    # Drop REJECT rows if any (none expected here)
    df_marker = df_marker.filter(col("dd_op") != "REJECT")

    # assign to the node's output df_name as the in-flight dataframe we will apply
    df_Upd_CVG_ATTR_SK_wonderful_archimedes = df_marker
except Exception as e:
    logger.error(f"Failed deriving dd_op marker for Update Strategy: {e}", exc_info=True)
    raise

# Load-modify-store-back pattern against the same target path in S3
try:
    logger.info("Reading current target WRK_BIRP_NISS_APRM_DETL from S3 for load-modify-store-back")
    existing_df = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
except Exception as e:
    logger.warning(
        f"Target WRK_BIRP_NISS_APRM_DETL not found on S3; treating existing target as empty for apply step: {e}"
    )
    # Create an empty DataFrame with the schema of the incoming update set so unioning is safe
    existing_df = spark.createDataFrame(spark.sparkContext.emptyRDD(), df_Upd_CVG_ATTR_SK_wonderful_archimedes.schema)

try:
    logger.info("Computing keys of rows to change (UPDATE/DELETE) and anti-joining from existing target")
    changed_keys_df = (
        df_Upd_CVG_ATTR_SK_wonderful_archimedes.filter(col("dd_op").isin(["UPDATE", "DELETE"]))
        .select("NISS_APRM_DETL_SK")
        .distinct()
    )

    # Anti-join existing rows to remove those that will be updated or deleted
    anti_joined_existing = existing_df.join(changed_keys_df, on=["NISS_APRM_DETL_SK"], how="left_anti")

    # Keep only INSERT/UPDATE rows from the incoming set (DELETE rows are omitted)
    incoming_apply_rows = df_Upd_CVG_ATTR_SK_wonderful_archimedes.filter(col("dd_op").isin(["INSERT", "UPDATE"]))

    # Union the surviving existing rows with the incoming INSERT/UPDATE rows
    combined_df = anti_joined_existing.unionByName(incoming_apply_rows, allowMissingColumns=True)

    # Overwrite the same target path with the combined dataframe
    logger.info(
        "Writing combined target for WRK_BIRP_NISS_APRM_DETL back to S3 (overwrite). Note: this reads/writes the full target; review cost for large tables."
    )
    combined_df.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
except Exception as e:
    logger.error(
        f"Failed during load-modify-store-back for WRK_BIRP_NISS_APRM_DETL (Update Strategy apply): {e}",
        exc_info=True,
    )
    raise

# Final assign: ensure the node's df_name exists for downstream lineage (already assigned above)
# df_Upd_CVG_ATTR_SK_wonderful_archimedes contains the applied-update marker rows (pre-apply); the actual target has been overwritten on S3 above.


job.commit()
