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

# -----------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD (try S3 parquet first, then Glue Catalog)
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting to read WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from S3 parquet")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_mendel = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD/")
    )
    logger.info("Read WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from S3 successfully")
except Exception as e:
    logger.warning(f"Failed to read WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from S3; falling back to Glue Catalog: {e}")
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from Glue Data Catalog")
        dyf = glueContext.create_dynamic_frame_from_catalog(
            database=GLUE_DATABASE,
            table_name="WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD",
        )
        df_temp = dyf.toDF()
        # project exactly the source fields listed in the node's metadata
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_mendel = df_temp.selectExpr(
            "SALN",
            "SRC_CLM_NUM",
            "SRC_CLM_UNIT_NUM",
            "PLCY_NUM",
            "SRC_UNIT_TYP",
            "SRC_RSRV_TYP",
            "CLS_CLM_CD",
            "TRAN_TMSP",
            "PAID_INDEMNITY_AMT",
            "LATE_PYMT_INT_AMT",
            "ACCT_POST_YR",
            "ACCT_POST_MNTH",
            "NISS_CMPY_CD",
            "NISS_ST_CD",
            "SAP_CMPY_CD",
            "PLCY_ST_POSTAL_CD",
            "ST_CD",
            "ACCOUNTING_LOB",
            "BOOK_OF_BUSINESS",
            "SUB_BOOK_OF_BUSINESS",
            "SOURCE_DATA_CD",
        )
        logger.info("Read WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from Glue Catalog and projected expected columns")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from Glue Catalog: {e2}", exc_info=True)
        raise

# -----------------------------------------------------------------------------
# SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD: Application Source Qualifier
# No SQL override - pass through and explicitly project every listed column
# -----------------------------------------------------------------------------
try:
    logger.info("Applying SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD projection from upstream source")
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_sleepy_pasteur = (
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_mendel.selectExpr(
            "SALN",
            "SRC_CLM_NUM",
            "SRC_CLM_UNIT_NUM",
            "PLCY_NUM",
            "SRC_UNIT_TYP",
            "SRC_RSRV_TYP",
            "CLS_CLM_CD",
            "TRAN_TMSP",
            "PAID_INDEMNITY_AMT",
            "LATE_PYMT_INT_AMT",
            "ACCT_POST_YR",
            "ACCT_POST_MNTH",
            "NISS_CMPY_CD",
            "NISS_ST_CD",
            "SAP_CMPY_CD",
            "PLCY_ST_POSTAL_CD",
            "ST_CD",
            "ACCOUNTING_LOB",
            "BOOK_OF_BUSINESS",
            "SUB_BOOK_OF_BUSINESS",
            "SOURCE_DATA_CD",
        )
    )
except Exception as e:
    logger.error(f"Failed processing SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# CLRF_exp: Expression (pure passthrough) - project every column explicitly
# -----------------------------------------------------------------------------
try:
    logger.info("Applying CLRF_exp passthrough projection")
    df_CLRF_exp_brave_turing = df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_sleepy_pasteur.selectExpr(
        "SALN",
        "SRC_CLM_NUM",
        "SRC_CLM_UNIT_NUM",
        "PLCY_NUM",
        "SRC_UNIT_TYP",
        "SRC_RSRV_TYP",
        "CLS_CLM_CD",
        "TRAN_TMSP",
        "PAID_INDEMNITY_AMT",
        "LATE_PYMT_INT_AMT",
        "ACCT_POST_YR",
        "ACCT_POST_MNTH",
        "NISS_CMPY_CD",
        "NISS_ST_CD",
        "SAP_CMPY_CD",
        "PLCY_ST_POSTAL_CD",
        "ST_CD",
        "ACCOUNTING_LOB",
        "BOOK_OF_BUSINESS",
        "SUB_BOOK_OF_BUSINESS",
        "SOURCE_DATA_CD",
    )
except Exception as e:
    logger.error(f"Failed processing CLRF_exp: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_DERIVE: Expression - passthrough + derived LAW5106_AMT
# iif(LATE_PYMT_INT_AMT>0 , LATE_PYMT_INT_AMT, iif(trim(SRC_RSRV_TYP)='1ST PARTY PLAINT ATTY FEE', PAID_INDEMNITY_AMT, 0))
# Translated to Spark SQL CASE expression; alias output column as LAW5106_AMT to match downstream Output node's expected field
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_DERIVE: passthrough columns + derived LAW5106_AMT")
    df_EXP_DERIVE_fierce_ramanujan = df_CLRF_exp_brave_turing.selectExpr(
        "SALN",
        "SRC_CLM_NUM",
        "SRC_CLM_UNIT_NUM",
        "PLCY_NUM",
        "SRC_UNIT_TYP",
        "SRC_RSRV_TYP",
        "CLS_CLM_CD",
        "TRAN_TMSP",
        "PAID_INDEMNITY_AMT",
        "LATE_PYMT_INT_AMT",
        "ACCT_POST_YR",
        "ACCT_POST_MNTH",
        "NISS_CMPY_CD",
        "NISS_ST_CD",
        "SAP_CMPY_CD",
        "PLCY_ST_POSTAL_CD",
        "ST_CD",
        "ACCOUNTING_LOB",
        "BOOK_OF_BUSINESS",
        "SUB_BOOK_OF_BUSINESS",
        "SOURCE_DATA_CD",
        # Derived column: translate nested IIF to CASE WHEN
        "CASE WHEN LATE_PYMT_INT_AMT > 0 THEN LATE_PYMT_INT_AMT \
              WHEN TRIM(SRC_RSRV_TYP) = '1ST PARTY PLAINT ATTY FEE' THEN PAID_INDEMNITY_AMT \
              ELSE 0 END AS LAW5106_AMT",
    )
except Exception as e:
    logger.error(f"Failed processing EXP_DERIVE: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Output: Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD -> write parquet to S3 (strip Shortcut_to_ prefix)
# Target real table name: WRK_BIRP_N31A_ALOSS_DTL_LOAD
# -----------------------------------------------------------------------------
# assign incoming dataframe to the output node's df_name
df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_optimistic_socrates = df_EXP_DERIVE_fierce_ramanujan

try:
    logger.info("Writing WRK_BIRP_N31A_ALOSS_DTL_LOAD to S3 as parquet (overwrite)")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_optimistic_socrates.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_DTL_LOAD/"
    )
    logger.info("Successfully wrote WRK_BIRP_N31A_ALOSS_DTL_LOAD to S3")
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_N31A_ALOSS_DTL_LOAD to S3: {e}", exc_info=True)
    raise


job.commit()
