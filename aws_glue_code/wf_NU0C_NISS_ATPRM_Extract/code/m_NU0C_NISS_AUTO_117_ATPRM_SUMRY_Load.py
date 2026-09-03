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

from pyspark.sql.functions import expr, col, lit, row_number, broadcast
from pyspark.sql.window import Window

# Placeholder constants
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
GLUE_CATALOG_DATABASE = "REPLACE_WITH_GLUE_CATALOG_DATABASE"

# Source: FDR_LIB_WRK_BIRP_NISS_APRM_FINAL - try staged parquet in S3 first, then fall back to Glue Catalog
try:
    logger.info("Attempting to read staged parquet for FDR_LIB_WRK_BIRP_NISS_APRM_FINAL from S3")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_nice_einstein = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_FINAL/"
    )
    logger.info("Read WRK_BIRP_NISS_APRM_FINAL from staged S3 path")
except Exception as e:
    logger.warning(
        "Staged parquet for WRK_BIRP_NISS_APRM_FINAL not found in S3; falling back to Glue Data Catalog read"
    )
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_FINAL from Glue Data Catalog as fallback")
        dyf = glueContext.create_dynamic_frame_from_catalog(
            database=GLUE_CATALOG_DATABASE, table_name="WRK_BIRP_NISS_APRM_FINAL"
        )
        df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_nice_einstein = dyf.toDF()
        logger.info("Read WRK_BIRP_NISS_APRM_FINAL from Glue Data Catalog")
    except Exception as e2:
        logger.error(
            f"Failed reading WRK_BIRP_NISS_APRM_FINAL from Glue Catalog fallback: {e2}",
            exc_info=True,
        )
        raise

# Application Source Qualifier: SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL
# This SQ had a SQL override against FDR.WRK_BIRP_NISS_APRM_FINAL; since that table is staged above,
# register the staged dataframe as a temp view named 'WRK_BIRP_NISS_APRM_FINAL' and run the rewritten SQL against it.
try:
    logger.info(
        "Registering temp view WRK_BIRP_NISS_APRM_FINAL for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL and executing rewritten SQL override"
    )
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_nice_einstein.createOrReplaceTempView("WRK_BIRP_NISS_APRM_FINAL")

    sql_query = f"""SELECT
    *
FROM
    WRK_BIRP_NISS_APRM_FINAL
"""

    # Execute the rewritten override against the temp view
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_loving_descartes = spark.sql(sql_query)
    logger.info("Executed rewritten SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL")
except Exception as e:
    logger.error(f"Failed processing SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL: {e}", exc_info=True)
    raise

# Expression: EXP_Passthru - pure passthrough from SQ
try:
    logger.info("Applying EXP_Passthru passthrough projection")
    # All columns from the SQ are passed through unchanged
    df_EXP_Passthru_laughing_galileo = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_loving_descartes
except Exception as e:
    logger.error(f"Failed EXP_Passthru: {e}", exc_info=True)
    raise

# Expression: EXP_Pass_Tgt - project passthrough columns, omit missing audit-mapplet columns, then generate surrogate key
try:
    logger.info(
        "Applying EXP_Pass_Tgt projection and generating surrogate key NISS_APRM_SUMRY_SK (Sequence Generator semantics via row_number())"
    )

    # NOTE: The mapping referenced an audit mapplet (mplt_FDR_LIB_ABC_MAPPING_AUDIT) whose dataframe was missing.
    # Per migration guidance, any columns that would have come only from that audit mapplet are omitted here; do not fabricate them.
    # Project all available columns from the upstream passthrough dataframe explicitly.
    available_cols = df_EXP_Passthru_laughing_galileo.columns
    # Build an explicit select list from the available columns rather than using a '*' wildcard
    df_temp_projection = df_EXP_Passthru_laughing_galileo.select([col(c) for c in available_cols])

    # Sequence Generator semantics: gap-free NEXTVAL implemented as row_number() over a single ordering (Window.orderBy(lit(1))).
    # This forces a single-partition shuffle and should be reviewed if input volume is very large.
    seq_window = Window.orderBy(lit(1))

    # Attach the surrogate key after projecting other columns to avoid referencing a non-existent column
    df_EXP_Pass_Tgt_pensive_plato = df_temp_projection.withColumn(
        "NISS_APRM_SUMRY_SK", row_number().over(seq_window)
    )
except Exception as e:
    logger.error(f"Failed EXP_Pass_Tgt projection or sequence generation: {e}", exc_info=True)
    raise

# Output: FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY - write as parquet to S3 (overwrite)
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_SUMRY to S3 as parquet (overwrite)")
    # assign final df_name as expected by downstream lineage
    df_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY_upbeat_franklin = df_EXP_Pass_Tgt_pensive_plato

    df_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY_upbeat_franklin.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_SUMRY/"
    )
    logger.info("Successfully wrote WRK_BIRP_NISS_APRM_SUMRY to S3")
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_SUMRY to S3: {e}", exc_info=True)
    raise


job.commit()
