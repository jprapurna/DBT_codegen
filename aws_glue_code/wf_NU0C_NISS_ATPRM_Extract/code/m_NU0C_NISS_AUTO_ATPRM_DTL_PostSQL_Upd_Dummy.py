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

# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 (S3-first read of intermediate WRK_ parquet, fallback to Glue Catalog)
logger.info("Attempting to read Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 from S3 path")
try:
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_clever_franklin = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL_1/")
    logger.info("Successfully read Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 from S3")
except Exception as e:
    # Allowed fallback: try Glue Catalog (or other configured source) when the staged parquet is not present
    logger.warning("S3 read failed for Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1; falling back to Glue Catalog read: %s", str(e))
    try:
        logger.info(f"Reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 from Glue Catalog database '{GLUE_DATABASE}' table 'WRK_BIRP_NISS_APRM_DETL_1'")
        dyf_tmp = glueContext.create_dynamic_frame_from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL_1")
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_clever_franklin = dyf_tmp.toDF()
    except Exception as e2:
        logger.error(f"Failed reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 from Glue Catalog: {e2}", exc_info=True)
        raise

# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 (bypassed — SQL Override below reads it directly)
sql_query = f"""select
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    BI_LMT,
    PRD_GRP_CD,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND
from
    FDR.WRK_BIRP_NISS_APRM_DETL
where
    1=2
"""

# read the SQL-override result from Snowflake via JDBC
try:
    logger.info("Reading SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1 from Snowflake via JDBC override query")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_gentle_euclid = (
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

# EXPTRANS: explicit passthrough projection of specified ports
try:
    logger.info("Applying EXPTRANS projection to produce df_EXPTRANS_humble_socrates")
    df_EXPTRANS_humble_socrates = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_1_gentle_euclid.selectExpr(
        "NISS_APRM_DETL_SK",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "BI_LMT",
        "PRD_GRP_CD",
        "NJ_NO_LWST_LMT_IND",
        "NJ_NMD_DRVR_EXCL_IND"
    )
except Exception as e:
    logger.error(f"Failed processing EXPTRANS: {e}", exc_info=True)
    raise

# assign output DF name for downstream lineage
df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_admiring_pascal = df_EXPTRANS_humble_socrates

# write intermediate WRK_BIRP_NISS_APRM_DETL to S3 as parquet (overwrite)
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL to S3 as parquet (overwrite)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_admiring_pascal.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL to S3: {e}", exc_info=True)
    raise


job.commit()
