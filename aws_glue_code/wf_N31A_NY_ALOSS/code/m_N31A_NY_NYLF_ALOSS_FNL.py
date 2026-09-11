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

# Source: Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD (S3-first, fallback to Glue Catalog)
try:
    logger.info("Attempting to read Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3")
    df_temp = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_DTL_LOAD/")
    # project exactly the listed fields
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_nifty_curie = df_temp.selectExpr(
        'SALN',
        'SRC_CLM_NUM',
        'SRC_CLM_UNIT_NUM',
        'PLCY_NUM',
        'SRC_UNIT_TYP',
        'SRC_RSRV_TYP',
        'CLS_CLM_CD',
        'TRAN_TMSP',
        'PAID_INDEMNITY_AMT',
        'LATE_PYMT_INT_AMT',
        'LAW5106_AMT',
        'ACCT_POST_YR',
        'ACCT_POST_MNTH',
        'NISS_CMPY_CD',
        'NISS_ST_CD',
        'SAP_CMPY_CD',
        'PLCY_ST_POSTAL_CD',
        'ST_CD',
        'ACCOUNTING_LOB',
        'BOOK_OF_BUSINESS',
        'SUB_BOOK_OF_BUSINESS',
        'SOURCE_DATA_CD'
    )
    logger.info("Successfully read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3")
except Exception as e:
    logger.warning(f"Failed to read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3, falling back to Glue Catalog: {e}")
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Data Catalog")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_N31A_ALOSS_DTL_LOAD")
        df_tmp = dyf.toDF()
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_nifty_curie = df_tmp.selectExpr(
            'SALN',
            'SRC_CLM_NUM',
            'SRC_CLM_UNIT_NUM',
            'PLCY_NUM',
            'SRC_UNIT_TYP',
            'SRC_RSRV_TYP',
            'CLS_CLM_CD',
            'TRAN_TMSP',
            'PAID_INDEMNITY_AMT',
            'LATE_PYMT_INT_AMT',
            'LAW5106_AMT',
            'ACCT_POST_YR',
            'ACCT_POST_MNTH',
            'NISS_CMPY_CD',
            'NISS_ST_CD',
            'SAP_CMPY_CD',
            'PLCY_ST_POSTAL_CD',
            'ST_CD',
            'ACCOUNTING_LOB',
            'BOOK_OF_BUSINESS',
            'SUB_BOOK_OF_BUSINESS',
            'SOURCE_DATA_CD'
        )
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Catalog: {e2}", exc_info=True)
        raise

# SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD: SQL Override rewritten to run against staged temp view
try:
    logger.info("Registering temp view WRK_BIRP_N31A_ALOSS_DTL_LOAD for SQL override and executing SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD")
    # register the dataframe produced above as the temp view the override references
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_nifty_curie.createOrReplaceTempView("WRK_BIRP_N31A_ALOSS_DTL_LOAD")
    sql_query = f"""select SRC_RSRV_TYP,
    sum(PAID_INDEMNITY_AMT) as PAID_INDEMNITY_AMT,
    sum(LATE_PYMT_INT_AMT) as LATE_PYMT_INT_AMT,
    sum(LAW5106_AMT) as LAW5106_AMT,
    ACCT_POST_YR,
    NISS_CMPY_CD,
    SAP_CMPY_CD
from
    WRK_BIRP_N31A_ALOSS_DTL_LOAD
group by SRC_RSRV_TYP,ACCT_POST_YR,NISS_CMPY_CD,SAP_CMPY_CD
"""
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_charming_schrodinger = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed processing SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD: {e}", exc_info=True)
    raise

# DRV_EXP: explicit passthrough projection
try:
    logger.info("Processing DRV_EXP expression projection")
    df_DRV_EXP_stoic_darwin = df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_charming_schrodinger.selectExpr(
        'SRC_RSRV_TYP',
        'ACCT_POST_YR',
        'NISS_CMPY_CD',
        'SAP_CMPY_CD',
        'PAID_INDEMNITY_AMT',
        'LATE_PYMT_INT_AMT',
        'LAW5106_AMT'
    )
except Exception as e:
    logger.error(f"Failed processing DRV_EXP: {e}", exc_info=True)
    raise

# passthrough to the Output node's expected dataframe name
df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_amazing_spinoza = df_DRV_EXP_stoic_darwin

# write intermediate WRK_ table as parquet to S3 (overwrite)
try:
    logger.info("Writing WRK_BIRP_N31A_ALOSS_FNL_LOAD to S3 as parquet (overwrite)")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_amazing_spinoza.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_FNL_LOAD/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_N31A_ALOSS_FNL_LOAD to S3: {e}", exc_info=True)
    raise


job.commit()
