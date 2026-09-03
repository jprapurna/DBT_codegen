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
GLUE_CATALOG_DATABASE = "REPLACE_WITH_GLUE_CATALOG_DATABASE"

# Source: Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD (s3-first with Glue Catalog fallback)
try:
    logger.info("Attempting to read staged parquet for WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from S3")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_mendel = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD/")
        .selectExpr(
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
    logger.warning("Staged parquet for WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD not found on S3, falling back to Glue Catalog read")
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from Glue Data Catalog")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=GLUE_CATALOG_DATABASE, table_name="WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD")
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_mendel = (
            dyf.toDF().selectExpr(
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
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from Glue Catalog: {e2}", exc_info=True)
        raise

# SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD: pass-through projection from upstream source
try:
    logger.info("Projecting columns for SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD")
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_sleepy_pasteur = df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_mendel.selectExpr(
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
    logger.error(f"Failed projecting SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD: {e}", exc_info=True)
    raise

# CLRF_exp: explicit passthrough projection (no derived columns)
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
    logger.error(f"Failed in CLRF_exp transformation: {e}", exc_info=True)
    raise

# EXP_DERIVE: derive O_LAW5106_AMT per mapping logic and pass through all other columns
try:
    logger.info("Applying EXP_DERIVE to derive O_LAW5106_AMT and pass through columns")
    # Translate Informatica iif(...) to SQL CASE expression
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
        "CASE WHEN LATE_PYMT_INT_AMT > 0 THEN LATE_PYMT_INT_AMT WHEN trim(SRC_RSRV_TYP) = '1ST PARTY PLAINT ATTY FEE' THEN PAID_INDEMNITY_AMT ELSE 0 END AS O_LAW5106_AMT",
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
    logger.error(f"Failed in EXP_DERIVE transformation: {e}", exc_info=True)
    raise

# Prepare final Output projection and write as parquet to S3 (overwrite)
try:
    logger.info("Preparing final projection for Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD and writing to S3 as parquet (overwrite)")
    # Map derived O_LAW5106_AMT into expected target column LAW5106_AMT
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_optimistic_socrates = df_EXP_DERIVE_fierce_ramanujan.selectExpr(
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
        "O_LAW5106_AMT AS LAW5106_AMT",
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

    # write intermediate WRK_ table as parquet to S3 (overwrite)
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_optimistic_socrates.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_DTL_LOAD/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_N31A_ALOSS_DTL_LOAD to S3: {e}", exc_info=True)
    raise


job.commit()
