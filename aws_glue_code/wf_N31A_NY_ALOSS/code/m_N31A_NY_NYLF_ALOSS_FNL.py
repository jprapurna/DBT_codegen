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

# Note: SNOWFLAKE_URL / SNOWFLAKE_USER / SNOWFLAKE_PASSWORD and logger/spark/glueContext are
# provided by the bootstrap above this code block.

# Attempt S3-first read for WRK_BIRP_N31A_ALOSS_DTL_LOAD (intermediate WRK_ table), fallback to Glue Catalog
try:
    logger.info("Attempting to read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3 path")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_nifty_curie = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_DTL_LOAD/")
        .selectExpr(
            "PAID_INDEMNITY_AMT",
            "SRC_RSRV_TYP",
            "LATE_PYMT_INT_AMT",
            "LAW5106_AMT",
            "ACCT_POST_YR",
            "NISS_CMPY_CD",
            "SAP_CMPY_CD",
        )
    )
    logger.info("Successfully read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3")
except Exception as e:
    # Allowed fallback: try Glue Data Catalog when S3 path is not present
    logger.warning(f"Failed to read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3, falling back to Glue Catalog: {e}")
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Data Catalog")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_N31A_ALOSS_DTL_LOAD")
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_nifty_curie = (
            dyf.toDF()
            .selectExpr(
                "PAID_INDEMNITY_AMT",
                "SRC_RSRV_TYP",
                "LATE_PYMT_INT_AMT",
                "LAW5106_AMT",
                "ACCT_POST_YR",
                "NISS_CMPY_CD",
                "SAP_CMPY_CD",
            )
        )
        logger.info("Successfully read WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Catalog")
    except Exception as e2:
        logger.error(f"Failed to read WRK_BIRP_N31A_ALOSS_DTL_LOAD from both S3 and Glue Catalog: {e2}", exc_info=True)
        raise

# SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD: staged SQL override against WRK_BIRP_N31A_ALOSS_DTL_LOAD
sql_query = f"""select
    SRC_RSRV_TYP,
    sum(PAID_INDEMNITY_AMT) as PAID_INDEMNITY_AMT,
    sum(LATE_PYMT_INT_AMT) as LATE_PYMT_INT_AMT,
    sum(LAW5106_AMT) as LAW5106_AMT,
    ACCT_POST_YR,
    NISS_CMPY_CD,
    SAP_CMPY_CD
from
    WRK_BIRP_N31A_ALOSS_DTL_LOAD
group by
    SRC_RSRV_TYP, ACCT_POST_YR, NISS_CMPY_CD, SAP_CMPY_CD
"""

try:
    logger.info("Registering upstream staged dataframe as temp view WRK_BIRP_N31A_ALOSS_DTL_LOAD and executing SQL override")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_nifty_curie.createOrReplaceTempView("WRK_BIRP_N31A_ALOSS_DTL_LOAD")
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_charming_schrodinger = spark.sql(sql_query)
    logger.info("Successfully executed SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD via spark.sql")
except Exception as e:
    logger.error(f"Failed executing SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD SQL override: {e}", exc_info=True)
    raise

# DRV_EXP: explicit passthrough projection of every OUTPUT/INPUT-OUTPUT port
try:
    logger.info("Applying DRV_EXP passthrough projection")
    df_DRV_EXP_stoic_darwin = df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_charming_schrodinger.selectExpr(
        "SRC_RSRV_TYP",
        "ACCT_POST_YR",
        "NISS_CMPY_CD",
        "SAP_CMPY_CD",
        "PAID_INDEMNITY_AMT",
        "LATE_PYMT_INT_AMT",
        "LAW5106_AMT",
    )
    logger.info("DRV_EXP projection complete")
except Exception as e:
    logger.error(f"Failed applying DRV_EXP projection: {e}", exc_info=True)
    raise

# Final mapping output assignment
df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_amazing_spinoza = df_DRV_EXP_stoic_darwin

# write intermediate WRK_ table as parquet to S3 (overwrite)
try:
    logger.info("Writing WRK_BIRP_N31A_ALOSS_FNL_LOAD to S3 as parquet (overwrite)")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_amazing_spinoza.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_FNL_LOAD/"
    )
    logger.info("Successfully wrote WRK_BIRP_N31A_ALOSS_FNL_LOAD to S3")
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_N31A_ALOSS_FNL_LOAD to S3: {e}", exc_info=True)
    raise


job.commit()
