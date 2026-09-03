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
GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"
FILTER_COND_FNL = "REPLACE_WITH_FILTER_COND_FNL_VALUE"

# Read staged intermediate WRK_BIRP_NISS_APRM_DETL from S3 first, fall back to Glue Catalog if missing
try:
    logger.info("Attempting to read staged WRK_BIRP_NISS_APRM_DETL from S3")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_determined_hawking = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
    logger.info("Successfully read WRK_BIRP_NISS_APRM_DETL from S3 staging path")
except Exception as e:
    logger.warning("Failed to read WRK_BIRP_NISS_APRM_DETL from S3; falling back to Glue Catalog source read: %s" % str(e))
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog database '%s'" % GLUE_DATABASE)
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_determined_hawking = dyf.toDF()
        logger.info("Successfully read WRK_BIRP_NISS_APRM_DETL from Glue Catalog")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog: {e2}", exc_info=True)
        raise

# SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL: SQL Override rewritten to run against the staged temp view
try:
    # register the upstream staged dataframe as a temp view named after the real table
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_determined_hawking.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

    sql_query = f"""select
    CVG_ATTR_SK,
    APRM_TYPE,
    APRM_VALUE
from
    WRK_BIRP_NISS_APRM_DETL
where
    {FILTER_COND_FNL}
"""
    logger.info("Executing SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL against temp view WRK_BIRP_NISS_APRM_DETL")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_einstein = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# EXP_PassThru: explicit passthrough projection (no '*' wildcards)
try:
    logger.info("Applying EXP_PassThru projection")
    # Project only the SQ output columns explicitly
    df_EXP_PassThru_keen_darwin = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_einstein.selectExpr(
        "CVG_ATTR_SK",
        "APRM_TYPE",
        "APRM_VALUE"
    )
except Exception as e:
    logger.error(f"Failed EXP_PassThru transformation: {e}", exc_info=True)
    raise

# EXP_PassThru_Tgt: derive target columns, map CVG_ATTR_SK -> NISS_APRM_FINAL_SK, omit mapping-audit mapplet join/columns (not present in this export)
try:
    logger.info("Applying EXP_PassThru_Tgt projection and deriving NISS_APRM_FINAL_SK from CVG_ATTR_SK")
    # Note: the mapping-audit mapplet (mplt_FDR_LIB_ABC_MAPPING_AUDIT) is missing from this export.
    # Any audit columns (CR_BY_MAPNG_ID, DW_CR_TMSP, UPD_BY_MAPNG_ID, etc.) that would have come from it are intentionally omitted.
    df_EXP_PassThru_Tgt_mystifying_hopper = df_EXP_PassThru_keen_darwin.selectExpr(
        "CVG_ATTR_SK AS NISS_APRM_FINAL_SK",
        "CVG_ATTR_SK",
        "APRM_TYPE",
        "APRM_VALUE"
    )
except Exception as e:
    logger.error(f"Failed EXP_PassThru_Tgt transformation: {e}", exc_info=True)
    raise

# write final WRK_BIRP_NISS_APRM_FINAL to S3 as parquet (overwrite)
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_FINAL to S3 as parquet (overwrite)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_affectionate_turing = df_EXP_PassThru_Tgt_mystifying_hopper
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_affectionate_turing.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_FINAL/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_FINAL to S3: {e}", exc_info=True)
    raise


job.commit()
