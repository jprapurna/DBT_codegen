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

FISCAL_YEAR = "REPLACE_WITH_FISCAL_YEAR_VALUE"
FISCAL_YEAR_PRV = "REPLACE_WITH_FISCAL_YEAR_PRV_VALUE"
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"

from pyspark.sql.types import StructType, StructField, StringType, DoubleType

# Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD1: create a placeholder dataframe variable so downstream metadata references resolve.
# This mapping's Application Source Qualifier contains a SQL Override that bypasses this Source in the default (non-staged) case,
# so no JDBC/catalog read is emitted here. We still assign a placeholder empty DataFrame to satisfy the mapping's df_name expectations.
try:
    logger.info("Creating placeholder empty DataFrame for Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD1 (bypassed by SQ override)")
    _schema_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD1 = StructType([
        StructField("SALN", StringType(), True),
        StructField("SRC_CLM_NUM", StringType(), True),
        StructField("SRC_CLM_UNIT_NUM", StringType(), True),
        StructField("PLCY_NUM", StringType(), True),
        StructField("SRC_UNIT_TYP", StringType(), True),
        StructField("SRC_RSRV_TYP", StringType(), True),
        StructField("CLS_CLM_CD", StringType(), True),
        StructField("TRAN_TMSP", StringType(), True),
        StructField("PAID_INDEMNITY_AMT", DoubleType(), True),
        StructField("LATE_PYMT_INT_AMT", DoubleType(), True),
        StructField("ACCT_POST_YR", StringType(), True),
        StructField("ACCT_POST_MNTH", StringType(), True),
        StructField("NISS_CMPY_CD", StringType(), True),
        StructField("NISS_ST_CD", StringType(), True),
        StructField("SAP_CMPY_CD", StringType(), True),
        StructField("PLCY_ST_POSTAL_CD", StringType(), True),
        StructField("ST_CD", StringType(), True),
        StructField("ACCOUNTING_LOB", StringType(), True),
        StructField("BOOK_OF_BUSINESS", StringType(), True),
        StructField("SUB_BOOK_OF_BUSINESS", StringType(), True),
        StructField("SOURCE_DATA_CD", StringType(), True),
    ])
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD1_jovial_hopper = spark.createDataFrame([], _schema_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD1)
except Exception as e:
    logger.error(f"Failed creating placeholder DataFrame for Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD1: {e}", exc_info=True)
    raise

# Source: Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD1 (bypassed — SQL Override below reads it directly)
sql_query = f"""select
    t3.SALN AS SALN,
    t3.SRC_CLM_NUM AS SRC_CLM_NUM,
    t3.SRC_CLM_UNIT_NUM AS SRC_CLM_UNIT_NUM,
    t3.PLCY_CNTRCT_NUM AS PLCY_NUM,
    t3.SRC_UNIT_TYP AS SRC_UNIT_TYP,
    t3.SRC_RSRV_TYP AS SRC_RSRV_TYP,
    t3.CLM_CLS_CD AS CLS_CLM_CD,
    t3.TRAN_TMSP AS TRAN_TMSP,
    t3.PD_INDMNTY_AMT AS PAID_INDEMNITY_AM,
    t3.LATE_PYMT_INT_AMT AS LATE_PYMT_INT_AMT,
    t3.ACCT_POST_YR_NUM AS ACCT_POST_YR,
    t3.ACCT_POST_MNTH_NUM AS ACCT_POST_MNTH,
    t3.NISS_CMPY_CD AS NISS_CMPY_CD,
    t3.NISS_ST_CD AS NISS_ST_CD,
    t3.SAP_CMPY_CD AS SAP_CMPY_CD,
    t3.PLCY_ST_POSTAL_CD AS PLCY_ST_POSTAL_CD,
    t3.FARMR_ST_CD AS ST_CD,
    t3.SAP_LOB_CD AS ACCOUNTING_LOB,
    t3.BOOK_OF_BUS_CD AS BOOK_OF_BUSINESS,
    t3.SUB_BOOK_OF_BUS_CD AS SUB_BOOK_OF_BUSINESS,
    t3.SRC_CD AS SOURCE_DATA_CD

from
((SELECT
ODS.SALN,
ODS.SRC_CLM_NUM,
U.SRC_CLM_UNIT_NUM,
C.PLCY_CNTRCT_NUM,
U.SRC_UNIT_TYP,
L.SRC_RSRV_TYP,
L.CLM_CLS_CD,
ODS.TRAN_TMSP,
L.PD_INDMNTY_AMT,
L.LATE_PYMT_INT_AMT,

L.ACCT_POST_YR_NUM,
L.ACCT_POST_MNTH_NUM,
C.NISS_CMPY_CD,
C.NISS_ST_CD,
C.SAP_CMPY_CD,
C.PLCY_ST_POSTAL_CD,
C.FARMR_ST_CD,
U.SAP_LOB_CD,
ODS.BOOK_OF_BUS_CD,
L.SUB_BOOK_OF_BUS_CD,
L.SRC_CD

FROM FDR.FDR_CLAIM_LEDGER_AUTO L

JOIN FDR.FDR_CLAIM_UNIT_AUTO U
ON   L.AUTO_CLM_LDGR_SK = U.AUTO_CLM_UNIT_SK

JOIN  FDR.FDR_CLAIM_AUTO C
ON   L.AUTO_CLM_SK = C.AUTO_CLM_SK

JOIN CLAIMS_ODS.CLM_LOSS_TRANS_FILE1 ODS ON ODS.CLM_LOSS_TRANS_SK=L.AUTO_CLM_LDGR_SK) t3 JOIN


(SELECT
distinct
ODS.SALN,
ODS.SRC_CLM_NUM,
U.SRC_CLM_UNIT_NUM


FROM FDR.FDR_CLAIM_LEDGER_AUTO L

JOIN FDR.FDR_CLAIM_UNIT_AUTO U
ON   L.AUTO_CLM_LDGR_SK = U.AUTO_CLM_UNIT_SK

JOIN  FDR.FDR_CLAIM_AUTO C
ON   L.AUTO_CLM_SK = C.AUTO_CLM_SK

JOIN CLAIMS_ODS.CLM_LOSS_TRANS_FILE1 ODS ON ODS.CLM_LOSS_TRANS_SK=L.AUTO_CLM_LDGR_SK

WHERE --1=1 AND
L.LATE_PYMT_INT_AMT >0 AND
 ltrim(rtrim(C.PLCY_ST_POSTAL_CD))='NY'
AND LTRIM(RTRIM(U.SRC_UNIT_TYP))='MED/PIP'
--AND LTRIM(RTRIM(L.SRC_RSRV_TYP))='1ST PARTY PLAINT ATTY FEE'
AND  TRIM(L.ACCT_POST_YR_NUM) IN ({FISCAL_YEAR})) t2

ON (t2.SALN=t3.SALN AND t2.SRC_CLM_NUM=t3.SRC_CLM_NUM AND t2.SRC_CLM_UNIT_NUM=t3.SRC_CLM_UNIT_NUM)

)
WHERE
ltrim(rtrim(t3.PLCY_ST_POSTAL_CD))='NY'
AND LTRIM(RTRIM(t3.SRC_UNIT_TYP))='MED/PIP'
AND (t3.LATE_PYMT_INT_AMT >0 or LTRIM(RTRIM(t3.SRC_RSRV_TYP))='1ST PARTY PLAINT ATTY FEE')
AND  TRIM(t3.ACCT_POST_YR_NUM) IN ({FISCAL_YEAR},{FISCAL_YEAR_PRV})
ORDER BY t3.SRC_CLM_NUM,t3.SRC_CLM_UNIT_NUM,t3.TRAN_TMSP
"""

# read the SQL-override result from Snowflake via JDBC
try:
    logger.info("Reading SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from Snowflake via JDBC override query")
    df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_clever_bohr = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(f"Failed reading SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD from Snowflake: {e}", exc_info=True)
    raise

# EXPTRANS: explicit projection of every listed port. Map PAID_INDEMNITY_AM (from SQ) -> PAID_INDEMNITY_AMT (expected downstream name)
try:
    logger.info("Applying EXPTRANS projection")
    df_EXPTRANS_focused_faraday = df_SQ_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_clever_bohr.selectExpr(
        "SALN",
        "SRC_CLM_NUM",
        "SRC_CLM_UNIT_NUM",
        "PLCY_NUM",
        "SRC_UNIT_TYP",
        "SRC_RSRV_TYP",
        "CLS_CLM_CD",
        "TRAN_TMSP",
        "PAID_INDEMNITY_AM AS PAID_INDEMNITY_AMT",
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
        "SOURCE_DATA_CD"
    )
except Exception as e:
    logger.error(f"Failed applying EXPTRANS projection: {e}", exc_info=True)
    raise

# write intermediate WRK_ table as parquet to S3 (overwrite)
try:
    logger.info("Writing WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD to S3 as parquet (overwrite)")
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_dirac = df_EXPTRANS_focused_faraday
    df_Shortcut_to_WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD_admiring_dirac.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_N31A_ALOSS_CLTF_LND_LOAD to S3: {e}", exc_info=True)
    raise


job.commit()
