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

from pyspark.sql.functions import col, concat, lit

# Placeholder constants for environment/mapping parameters
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
PM_TARGET_FILE_DIR = "REPLACE_WITH_PM_TARGET_FILE_DIR"
PM_BAD_FILE_DIR = "REPLACE_WITH_PM_BAD_FILE_DIR"
GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"

# Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD: staged WRK_ source (S3-first, fallback to Glue Catalog)
try:
    logger.info("Attempting to read staged WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3 path")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_DTL_LOAD/"
    )
    logger.info("Read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3 successfully")
except Exception as e:
    logger.warning("Staged S3 path for WRK_BIRP_N31A_ALOSS_DTL_LOAD not found or unreadable, falling back to Glue Catalog read: %s", str(e))
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Catalog database/table %s.%s", GLUE_DATABASE, "WRK_BIRP_N31A_ALOSS_DTL_LOAD")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_N31A_ALOSS_DTL_LOAD")
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac = dyf.toDF()
        # project exactly the listed columns to match Source ports
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac = df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac.selectExpr(
            "SALN",
            "SALN AS SALN",
            "SRC_CLM_NUM",
            "SRC_CLM_UNIT_NUM",
            "PLCY_NUM",
            "SRC_UNIT_TYP",
            "SRC_RSRV_TYP",
            "CLS_CLM_CD",
            "TRAN_TMSP",
            "PAID_INDEMNITY_AMT",
            "LATE_PYMT_INT_AMT",
            "LAW5106_AMT",
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
            "SOURCE_DATA_CD"
        )
        logger.info("Read WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Catalog successfully")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD: staged WRK_ source (S3-first, fallback to Glue Catalog)
try:
    logger.info("Attempting to read staged WRK_BIRP_N31A_ALOSS_FNL_LOAD from S3 path")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_FNL_LOAD/"
    )
    logger.info("Read WRK_BIRP_N31A_ALOSS_FNL_LOAD from S3 successfully")
except Exception as e:
    logger.warning("Staged S3 path for WRK_BIRP_N31A_ALOSS_FNL_LOAD not found or unreadable, falling back to Glue Catalog read: %s", str(e))
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_FNL_LOAD from Glue Catalog database/table %s.%s", GLUE_DATABASE, "WRK_BIRP_N31A_ALOSS_FNL_LOAD")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_N31A_ALOSS_FNL_LOAD")
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin = dyf.toDF()
        # project exactly the listed columns to match Source ports
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin = df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin.selectExpr(
            "SRC_RSRV_TYP",
            "SRC_RSRV_TYP AS SRC_RSRV_TYP",
            "ACCT_POST_YR",
            "NISS_CMPY_CD",
            "SAP_CMPY_CD",
            "PAID_INDEMNITY_AMT",
            "LATE_PYMT_INT_AMT",
            "LAW5106_AMT"
        )
        logger.info("Read WRK_BIRP_N31A_ALOSS_FNL_LOAD from Glue Catalog successfully")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_N31A_ALOSS_FNL_LOAD from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD: pass-through SQ, project explicit ports
try:
    logger.info("Projecting ports for SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD")
    # select exactly the ports listed by the SQ (no wildcard)
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_stoic_euclid = df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac.selectExpr(
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
        "LAW5106_AMT",
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
        "SOURCE_DATA_CD"
    )
except Exception as e:
    logger.error(f"Failed transforming SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD: {e}", exc_info=True)
    raise

# SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD: pass-through SQ, project explicit ports
try:
    logger.info("Projecting ports for SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD")
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_magical_kepler = df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin.selectExpr(
        "SRC_RSRV_TYP",
        "ACCT_POST_YR",
        "NISS_CMPY_CD",
        "SAP_CMPY_CD",
        "PAID_INDEMNITY_AMT",
        "LATE_PYMT_INT_AMT",
        "LAW5106_AMT"
    )
except Exception as e:
    logger.error(f"Failed transforming SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD: {e}", exc_info=True)
    raise

# exp_derive: preserve passthrough ports and derive V_SRC_CLM_UNIT_NUM = chr(39) || SRC_CLM_UNIT_NUM
try:
    logger.info("Starting Expression transformation exp_derive")
    # project passthrough columns first
    df_temp = df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_stoic_euclid.select(
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
        "LAW5106_AMT",
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
        "SOURCE_DATA_CD"
    )
    # then add the derived column V_SRC_CLM_UNIT_NUM using concat of single-quote (chr(39)) and SRC_CLM_UNIT_NUM
    df_exp_derive_blissful_turing = df_temp.withColumn(
        "V_SRC_CLM_UNIT_NUM",
        concat(lit("'"), col("SRC_CLM_UNIT_NUM"))
    ).select(
        # ensure output contains every OUTPUT/INPUT-OUTPUT port listed in the Expression node
        "SALN",
        "SRC_CLM_NUM",
        "SRC_CLM_UNIT_NUM",
        "V_SRC_CLM_UNIT_NUM",
        "PLCY_NUM",
        "SRC_UNIT_TYP",
        "SRC_RSRV_TYP",
        "CLS_CLM_CD",
        "TRAN_TMSP",
        "PAID_INDEMNITY_AMT",
        "LATE_PYMT_INT_AMT",
        "LAW5106_AMT",
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
        "SOURCE_DATA_CD"
    )
    logger.info("Completed Expression transformation exp_derive")
except Exception as e:
    logger.error(f"Failed in exp_derive transformation: {e}", exc_info=True)
    raise

# exp_derive1: simple passthrough projection of seven ports
try:
    logger.info("Starting Expression transformation exp_derive1 (passthrough)")
    df_exp_derive1_peaceful_lovelace = df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_magical_kepler.select(
        "SRC_RSRV_TYP",
        "ACCT_POST_YR",
        "NISS_CMPY_CD",
        "SAP_CMPY_CD",
        "PAID_INDEMNITY_AMT",
        "LATE_PYMT_INT_AMT",
        "LAW5106_AMT"
    )
    logger.info("Completed Expression transformation exp_derive1")
except Exception as e:
    logger.error(f"Failed in exp_derive1 transformation: {e}", exc_info=True)
    raise

# ff_NYLF_Detail_Report: flat-file target (NYLF_FLOSS_DETAIL_REPORT.csv) - convert to pandas and write to PM_TARGET_FILE_DIR
try:
    logger.info("Converting df_exp_derive_blissful_turing to pandas for ff_NYLF_Detail_Report write")
    df_pd = df_exp_derive_blissful_turing.toPandas()
    out_path = f"{PM_TARGET_FILE_DIR}/NYLF_FLOSS_DETAIL_REPORT.csv"
    df_pd.to_csv(out_path, index=False, mode='w')
    logger.info("Wrote ff_NYLF_Detail_Report to %s", out_path)
    df_ff_NYLF_Detail_Report_trusting_darwin = df_exp_derive_blissful_turing
except Exception as e:
    logger.error(f"Failed writing ff_NYLF_Detail_Report flat file: {e}", exc_info=True)
    raise

# ff_NYLF_FNL_REPORT: flat-file target (NYLF_FLOSS_FINAL_REPORT.csv) - convert to pandas and write to PM_TARGET_FILE_DIR
try:
    logger.info("Converting df_exp_derive1_peaceful_lovelace to pandas for ff_NYLF_FNL_REPORT write")
    df_pd2 = df_exp_derive1_peaceful_lovelace.toPandas()
    out_path2 = f"{PM_TARGET_FILE_DIR}/NYLF_FLOSS_FINAL_REPORT.csv"
    df_pd2.to_csv(out_path2, index=False, mode='w')
    logger.info("Wrote ff_NYLF_FNL_REPORT to %s", out_path2)
    df_ff_NYLF_FNL_REPORT_laughing_euclid = df_exp_derive1_peaceful_lovelace
except Exception as e:
    logger.error(f"Failed writing ff_NYLF_FNL_REPORT flat file: {e}", exc_info=True)
    raise


job.commit()
