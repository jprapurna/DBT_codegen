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

from pyspark.sql.functions import col, lit, concat

# Placeholder constants for environment / mapping parameters
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
SOURCE_DATABASE = "REPLACE_WITH_SOURCE_GLUE_DATABASE"
PM_TARGET_FILE_DIR = "REPLACE_WITH_PM_TARGET_FILE_DIR"
PM_BAD_FILE_DIR = "REPLACE_WITH_PM_BAD_FILE_DIR"

# ---------- Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD (Source - S3-first with Glue Catalog fallback) ----------
try:
    logger.info("Attempting to read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3 first")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_DTL_LOAD/")
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
    )
    logger.info("Successfully read WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3")
except Exception as e:
    logger.warning(f"Failed reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from S3, falling back to Glue Catalog: {e}")
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Data Catalog")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=SOURCE_DATABASE, table_name="WRK_BIRP_N31A_ALOSS_DTL_LOAD")
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac = (
            dyf.toDF()
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
        )
        logger.info("Successfully read WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Catalog")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_N31A_ALOSS_DTL_LOAD from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# ---------- Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD (Source - S3-first with Glue Catalog fallback) ----------
try:
    logger.info("Attempting to read WRK_BIRP_N31A_ALOSS_FNL_LOAD from S3 first")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_FNL_LOAD/")
        .selectExpr(
            "SRC_RSRV_TYP",
            "ACCT_POST_YR",
            "NISS_CMPY_CD",
            "SAP_CMPY_CD",
            "PAID_INDEMNITY_AMT",
            "LATE_PYMT_INT_AMT",
            "LAW5106_AMT"
        )
    )
    logger.info("Successfully read WRK_BIRP_N31A_ALOSS_FNL_LOAD from S3")
except Exception as e:
    logger.warning(f"Failed reading WRK_BIRP_N31A_ALOSS_FNL_LOAD from S3, falling back to Glue Catalog: {e}")
    try:
        logger.info("Reading WRK_BIRP_N31A_ALOSS_FNL_LOAD from Glue Data Catalog")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=SOURCE_DATABASE, table_name="WRK_BIRP_N31A_ALOSS_FNL_LOAD")
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin = (
            dyf.toDF()
            .selectExpr(
                "SRC_RSRV_TYP",
                "ACCT_POST_YR",
                "NISS_CMPY_CD",
                "SAP_CMPY_CD",
                "PAID_INDEMNITY_AMT",
                "LATE_PYMT_INT_AMT",
                "LAW5106_AMT"
            )
        )
        logger.info("Successfully read WRK_BIRP_N31A_ALOSS_FNL_LOAD from Glue Catalog")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_N31A_ALOSS_FNL_LOAD from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# ---------- SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD (Source Qualifier - passthrough projection) ----------
try:
    logger.info("Projecting explicit columns for SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD")
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_stoic_euclid = (
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_wonderful_dirac.selectExpr(
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
    )
    logger.info("Successfully projected SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD")
except Exception as e:
    logger.error(f"Failed projecting SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD: {e}", exc_info=True)
    raise

# ---------- SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD (Source Qualifier - passthrough projection) ----------
try:
    logger.info("Projecting explicit columns for SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD")
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_magical_kepler = (
        df_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_gifted_darwin.selectExpr(
            "SRC_RSRV_TYP",
            "ACCT_POST_YR",
            "NISS_CMPY_CD",
            "SAP_CMPY_CD",
            "PAID_INDEMNITY_AMT",
            "LATE_PYMT_INT_AMT",
            "LAW5106_AMT"
        )
    )
    logger.info("Successfully projected SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD")
except Exception as e:
    logger.error(f"Failed projecting SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD: {e}", exc_info=True)
    raise

# ---------- exp_derive (Expression - derive V_SRC_CLM_UNIT_NUM = chr(39)||SRC_CLM_UNIT_NUM and passthrough others) ----------
try:
    logger.info("Applying expression exp_derive to derive V_SRC_CLM_UNIT_NUM and project explicit columns")
    df_exp_derive_blissful_turing = (
        df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_DTL_LOAD_stoic_euclid.select(
            col("SALN"),
            col("SRC_CLM_NUM"),
            col("SRC_CLM_UNIT_NUM"),
            concat(lit("'"), col("SRC_CLM_UNIT_NUM")).alias("V_SRC_CLM_UNIT_NUM"),
            col("PLCY_NUM"),
            col("SRC_UNIT_TYP"),
            col("SRC_RSRV_TYP"),
            col("CLS_CLM_CD"),
            col("TRAN_TMSP"),
            col("PAID_INDEMNITY_AMT"),
            col("LATE_PYMT_INT_AMT"),
            col("LAW5106_AMT"),
            col("ACCT_POST_YR"),
            col("ACCT_POST_MNTH"),
            col("NISS_CMPY_CD"),
            col("NISS_ST_CD"),
            col("SAP_CMPY_CD"),
            col("PLCY_ST_POSTAL_CD"),
            col("ST_CD"),
            col("ACCOUNTING_LOB"),
            col("BOOK_OF_BUSINESS"),
            col("SUB_BOOK_OF_BUSINESS"),
            col("SOURCE_DATA_CD")
        )
    )
    logger.info("Successfully applied exp_derive")
except Exception as e:
    logger.error(f"Failed applying exp_derive: {e}", exc_info=True)
    raise

# ---------- exp_derive1 (Expression - pure passthrough projection) ----------
try:
    logger.info("Applying expression exp_derive1 (passthrough projection)")
    df_exp_derive1_peaceful_lovelace = (
        df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_FNL_LOAD_magical_kepler.select(
            col("SRC_RSRV_TYP"),
            col("ACCT_POST_YR"),
            col("NISS_CMPY_CD"),
            col("SAP_CMPY_CD"),
            col("PAID_INDEMNITY_AMT"),
            col("LATE_PYMT_INT_AMT"),
            col("LAW5106_AMT")
        )
    )
    logger.info("Successfully applied exp_derive1")
except Exception as e:
    logger.error(f"Failed applying exp_derive1: {e}", exc_info=True)
    raise

# ---------- ff_NYLF_Detail_Report (Output - flat file target) ----------
try:
    logger.info("Converting df_exp_derive_blissful_turing to pandas for ff_NYLF_Detail_Report output file")
    pdf = df_exp_derive_blissful_turing.toPandas()
    output_path = f"{PM_TARGET_FILE_DIR}/NYLF_FLOSS_DETAIL_REPORT.csv"
    logger.info(f"Writing ff_NYLF_Detail_Report to {output_path} (overwrite)")
    pdf.to_csv(output_path, index=False, mode="w")
except Exception as e:
    logger.error(f"Failed writing ff_NYLF_Detail_Report to file: {e}", exc_info=True)
    raise

# assign the output df variable name for lineage completeness
df_ff_NYLF_Detail_Report_trusting_darwin = df_exp_derive_blissful_turing

# ---------- ff_NYLF_FNL_REPORT (Output - flat file target) ----------
try:
    logger.info("Converting df_exp_derive1_peaceful_lovelace to pandas for ff_NYLF_FNL_REPORT output file")
    pdf2 = df_exp_derive1_peaceful_lovelace.toPandas()
    output_path2 = f"{PM_TARGET_FILE_DIR}/NYLF_FLOSS_FINAL_REPORT.csv"
    logger.info(f"Writing ff_NYLF_FNL_REPORT to {output_path2} (overwrite)")
    pdf2.to_csv(output_path2, index=False, mode="w")
except Exception as e:
    logger.error(f"Failed writing ff_NYLF_FNL_REPORT to file: {e}", exc_info=True)
    raise

# assign the output df variable name for lineage completeness
df_ff_NYLF_FNL_REPORT_laughing_euclid = df_exp_derive1_peaceful_lovelace


job.commit()
