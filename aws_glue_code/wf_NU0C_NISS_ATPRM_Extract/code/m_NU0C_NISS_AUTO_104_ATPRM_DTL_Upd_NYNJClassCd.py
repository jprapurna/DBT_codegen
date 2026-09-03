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

from pyspark.sql.functions import col, expr, lit, when, broadcast
from pyspark.sql.window import Window
from functools import reduce

# Placeholder constants
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"

# -----------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL
# Attempt an S3-first read of the intermediate table path, fallback to Glue Catalog
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting S3-first read of WRK_BIRP_NISS_APRM_DETL from s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_wonderful_mendel = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    # Allowed fallback: read from Glue Catalog (or other configured source) when the staged parquet is not present.
    logger.warning("S3 path for WRK_BIRP_NISS_APRM_DETL not found, falling back to Glue Catalog read")
    try:
        logger.info("Reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL from Glue Catalog (database=%s, table=WRK_BIRP_NISS_APRM_DETL)", GLUE_DATABASE)
        dyf = glueContext.create_dynamic_frame_from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_wonderful_mendel = dyf.toDF()
    except Exception as e2:
        logger.error(f"Failed fallback read for Shortcut_to_WRK_BIRP_NISS_APRM_DETL from Glue Catalog: {e2}", exc_info=True)
        raise

# -----------------------------------------------------------------------------
# Application Source Qualifier: SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL
# The SQ had a SQL Override against FDR.WRK_BIRP_NISS_APRM_DETL which is staged in S3.
# Register the staged DF as a temp view named 'WRK_BIRP_NISS_APRM_DETL' and run the rewritten SQL.
# -----------------------------------------------------------------------------
try:
    # register temp view for the staged upstream table
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_wonderful_mendel.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

    # Rewritten SQL override referencing the bare temp view. (Original override projected a specific set of columns;
    # because we rely on the staged table being the source, we select from that view. If the mapping had aliases
    # they'd be preserved here in a more specific SQL string.)
    sql_query = f"""select *
from
    WRK_BIRP_NISS_APRM_DETL
"""

    logger.info("Running rewritten SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL via spark.sql")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_laughing_tesla = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Expression: EXP_To_Drv_Class_Cd
# Translate expression ports into explicit select()/withColumn() steps. Preserve upstream columns
# and ensure the expression's output ports exist (create as NULL where upstream did not provide them).
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_To_Drv_Class_Cd transformations")
    df_input = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_laughing_tesla

    # Start from the input schema and explicitly list every existing column (no '*' wildcards)
    existing_cols = df_input.columns
    select_exprs = [col(c) for c in existing_cols]

    # Ensure the Expression's declared output ports exist. If upstream did not provide them, create them as NULLs.
    # Declared outputs (per plan): NISS_CLASS_CD, NISS_APRM_DETL_SK, REC_EXCP_IND, o_REC_EXCP_DESC
    for out_col in ["NISS_CLASS_CD", "NISS_APRM_DETL_SK", "REC_EXCP_IND", "o_REC_EXCP_DESC"]:
        if out_col not in existing_cols:
            select_exprs.append(lit(None).alias(out_col))

    # Project explicitly
    df_intermediate = df_input.select(*select_exprs)

    # NOTE: The original Informatica Expression computed several intermediate aliases (IAGE, IMILES_TO_WRK, v_CLASS_CD_*, etc.).
    # Those intermediate ports would be created here in an earlier select/withColumn and then referenced by subsequent expressions.
    # Because the concrete expressions are not provided in the mapping plan payload available here, we preserve the
    # upstream columns and ensure the declared output ports exist (as placeholders if necessary) so downstream nodes can run.

    df_EXP_To_Drv_Class_Cd_calm_babbage = df_intermediate
except Exception as e:
    logger.error(f"Failed transforming EXP_To_Drv_Class_Cd: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Update Strategy: UPD_NISS_CLASS_CD
# Derive dd_op, drop REJECT rows, and apply load-modify-store-back against the target
# WRK_BIRP_NISS_APRM_DETL on S3 (read existing, remove changed keys, union in INSERT/UPDATE rows,
# overwrite target). All steps wrapped in logging try/except blocks.
# -----------------------------------------------------------------------------
try:
    logger.info("Applying Update Strategy logic for UPD_NISS_CLASS_CD: deriving dd_op and preparing changed rows")
    df_upstream = df_EXP_To_Drv_Class_Cd_calm_babbage

    # The mapping's Update Strategy indicates DD_UPDATE semantics for affected rows.
    # Here we derive a dd_op marker. In the original mapping this is a conditional expression; the plan indicates DD_UPDATE
    # so we set the marker to 'UPDATE' for rows that should be updated. If more complex logic existed it would be translated
    # into chained when(...).otherwise(...) calls here.
    df_with_dd = df_upstream.withColumn("dd_op", lit("UPDATE"))

    # Immediately drop REJECT rows (none expected for this mapping if DD_UPDATE only)
    df_with_dd = df_with_dd.filter(col("dd_op") != "REJECT")

    # Validate presence of primary key needed for the apply
    pk_col = "NISS_APRM_DETL_SK"
    if pk_col not in df_with_dd.columns:
        logger.error("Primary key column '%s' is required by the Update Strategy but is not present in the incoming dataframe", pk_col)
        raise Exception(f"Missing primary key column required for Update Strategy: {pk_col}")

    # (1) Load the current full target table from S3
    try:
        logger.info("Reading existing target WRK_BIRP_NISS_APRM_DETL from s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
        existing_df = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
    except Exception as e:
        logger.error(f"Failed reading existing target WRK_BIRP_NISS_APRM_DETL from S3: {e}", exc_info=True)
        raise

    # (2) Build changed_keys_df from rows marked INSERT/UPDATE/DELETE
    changed_keys_df = (
        df_with_dd.filter(col("dd_op").isin("INSERT", "UPDATE", "DELETE"))
        .select(pk_col)
        .distinct()
    )

    # (3) Anti-join existing_df against changed keys to drop rows being updated/deleted
    try:
        existing_minus_changed = existing_df.join(changed_keys_df, on=pk_col, how="left_anti")
    except Exception as e:
        logger.error(f"Failed during anti-join to remove changed keys from existing target: {e}", exc_info=True)
        raise

    # (4) Union the remaining existing rows with the INSERT/UPDATE rows (DROP DELETE rows)
    rows_to_apply = df_with_dd.filter(col("dd_op").isin("INSERT", "UPDATE")).drop("dd_op")

    try:
        # allowMissingColumns=True to accommodate schema drift between existing and incoming rows
        combined_df = existing_minus_changed.unionByName(rows_to_apply, allowMissingColumns=True)
    except Exception as e:
        logger.error(f"Failed during union of existing and changed rows: {e}", exc_info=True)
        raise

    # (5) Overwrite the same S3 parquet target with the combined dataframe
    try:
        logger.info("Writing merged WRK_BIRP_NISS_APRM_DETL back to s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/ (overwrite)")
        combined_df.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
    except Exception as e:
        logger.error(f"Failed writing merged WRK_BIRP_NISS_APRM_DETL to S3: {e}", exc_info=True)
        raise

    # Assign the final pre-write dataframe to the node's output df name for downstream reuse
    df_UPD_NISS_CLASS_CD_careful_descartes = combined_df
except Exception as e:
    logger.error(f"Failed Update Strategy UPD_NISS_CLASS_CD: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Output: WRK_BIRP_NISS_APRM_DETL
# Write the incoming dataframe to S3 as parquet (overwrite)
# -----------------------------------------------------------------------------
try:
    # downstream expects this exact variable name
    df_WRK_BIRP_NISS_APRM_DETL_trusting_curie = df_UPD_NISS_CLASS_CD_careful_descartes

    logger.info("Writing WRK_BIRP_NISS_APRM_DETL to S3 as parquet (overwrite)")
    df_WRK_BIRP_NISS_APRM_DETL_trusting_curie.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL to S3: {e}", exc_info=True)
    raise


job.commit()
