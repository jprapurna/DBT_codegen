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

from pyspark.sql.functions import col, expr, when, trim, split, regexp_replace, lpad, format_string, round, lit
from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Placeholder constants for environment/run-specific values
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
PM_TARGET_FILE_DIR = "REPLACE_WITH_PM_TARGET_FILE_DIR"
# Output filename placeholders (taken from Informatica output_details)
OUTPUT_FILE_PREMRPT1_DET = "REPLACE_WITH_OutputFile_PremRpt1_Det.csv"
OUTPUT_FILE_PREMRPT_EXC = "REPLACE_WITH_OutputFile_PremRpt_Exp.csv"
OUTPUT_FILE_PREMRPT3_SUM = "REPLACE_WITH_OutputFile_PremRpt3_Sum.csv"
OUTPUT_FILE_PREMRPT2_FNLCsv = "REPLACE_WITH_OutputFile_PremRpt2_FnlCsv.csv"
OUTPUT_FILE_PREMRPT2_FnlTxt = "REPLACE_WITH_OutputFile_PremRpt2_FnlTxt.txt"

# Glue-catalog fallback placeholders (used if staged S3 path not present)
GLUE_CATALOG_DATABASE = "REPLACE_WITH_GLUE_CATALOG_DATABASE"
GLUE_CATALOG_TABLE = "REPLACE_WITH_GLUE_CATALOG_TABLE"

# 1) Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL1
try:
    logger.info("Attempting S3-first read for Shortcut_to_WRK_BIRP_NISS_APRM_DETL1 -> WRK_BIRP_NISS_APRM_DETL")
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_jovial_hopper = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
        .select(
            "REC_DROP_RSN_DESC",
            "NISS_TERR_CD",
            "CLNDR_YR",
            "CALL_YR",
            "BI_LMT",
            "CVG_AMT",
            "REC_EXCPN_IND",
            "TTL_WRITTN_PREM_AMT",
            "CVG_EXPS_VAL",
            "NISS_CVG_CD",
            "NISS_CLASS_CD",
            "SRC_CLM_NUM",
            "SRC_CLM_UNIT_NUM"
        )
    )
except Exception as e:
    logger.warning("S3 parquet for WRK_BIRP_NISS_APRM_DETL not found - falling back to Glue Catalog source read", exc_info=True)
    try:
        logger.info("Reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL1 from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_CATALOG_DATABASE, table_name=GLUE_CATALOG_TABLE)
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_jovial_hopper = (
            dyf.toDF()
            .select(
                "REC_DROP_RSN_DESC",
                "NISS_TERR_CD",
                "CLNDR_YR",
                "CALL_YR",
                "BI_LMT",
                "CVG_AMT",
                "REC_EXCPN_IND",
                "TTL_WRITTN_PREM_AMT",
                "CVG_EXPS_VAL",
                "NISS_CVG_CD",
                "NISS_CLASS_CD",
                "SRC_CLM_NUM",
                "SRC_CLM_UNIT_NUM"
            )
        )
    except Exception as e:
        logger.error(f"Failed reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL1 from fallback source: {e}", exc_info=True)
        raise

# 2) Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL (alternate staged copy)
try:
    logger.info("Attempting S3-first read for Shortcut_to_WRK_BIRP_NISS_APRM_DETL -> WRK_BIRP_NISS_APRM_DETL")
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_eager_tesla = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
        .select(
            "REC_DROP_RSN_DESC",
            "NISS_TERR_CD",
            "CLNDR_YR",
            "CALL_YR",
            "BI_LMT",
            "CVG_AMT",
            "REC_EXCPN_IND",
            "TTL_WRITTN_PREM_AMT",
            "CVG_EXPS_VAL",
            "NISS_CVG_CD",
            "NISS_CLASS_CD",
            "SRC_CLM_NUM",
            "SRC_CLM_UNIT_NUM"
        )
    )
except Exception as e:
    logger.warning("S3 parquet for WRK_BIRP_NISS_APRM_DETL (alternate) not found - falling back to Glue Catalog source read", exc_info=True)
    try:
        logger.info("Reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_CATALOG_DATABASE, table_name=GLUE_CATALOG_TABLE)
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_eager_tesla = (
            dyf.toDF()
            .select(
                "REC_DROP_RSN_DESC",
                "NISS_TERR_CD",
                "CLNDR_YR",
                "CALL_YR",
                "BI_LMT",
                "CVG_AMT",
                "REC_EXCPN_IND",
                "TTL_WRITTN_PREM_AMT",
                "CVG_EXPS_VAL",
                "NISS_CVG_CD",
                "NISS_CLASS_CD",
                "SRC_CLM_NUM",
                "SRC_CLM_UNIT_NUM"
            )
        )
    except Exception as e:
        logger.error(f"Failed reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL (alternate) from fallback source: {e}", exc_info=True)
        raise

# 3) Source: FDR_LIB_WRK_BIRP_NISS_APRM_FINAL
try:
    logger.info("Attempting S3-first read for FDR_LIB_WRK_BIRP_NISS_APRM_FINAL -> WRK_BIRP_NISS_APRM_FINAL")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_nostalgic_planck = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_FINAL/")
        .select(
            "TTL_WRITTN_PREM_AMT",
            "CLNDR_YR",
            "CALL_YR",
            "CVG_EXPS_VAL",
            "NISS_CVG_CD",
            "NISS_CLASS_CD"
        )
    )
except Exception as e:
    logger.warning("S3 parquet for WRK_BIRP_NISS_APRM_FINAL not found - falling back to Glue Catalog source read", exc_info=True)
    try:
        logger.info("Reading FDR_LIB_WRK_BIRP_NISS_APRM_FINAL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_CATALOG_DATABASE, table_name=GLUE_CATALOG_TABLE)
        df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_nostalgic_planck = (
            dyf.toDF()
            .select(
                "TTL_WRITTN_PREM_AMT",
                "CLNDR_YR",
                "CALL_YR",
                "CVG_EXPS_VAL",
                "NISS_CVG_CD",
                "NISS_CLASS_CD"
            )
        )
    except Exception as e:
        logger.error(f"Failed reading FDR_LIB_WRK_BIRP_NISS_APRM_FINAL from fallback source: {e}", exc_info=True)
        raise

# 4) Source: FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY
try:
    logger.info("Attempting S3-first read for FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY -> WRK_BIRP_NISS_APRM_SUMRY")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY_focused_ramanujan = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_SUMRY/")
        .select(
            "NISS_CVG_CD",
            "NISS_CLASS_CD",
            "CLNDR_YR",
            "TTL_WRITTN_PREM_AMT",
            "TALLY",
            "SUM_PREM"
        )
    )
except Exception as e:
    logger.warning("S3 parquet for WRK_BIRP_NISS_APRM_SUMRY not found - falling back to Glue Catalog source read", exc_info=True)
    try:
        logger.info("Reading FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_CATALOG_DATABASE, table_name=GLUE_CATALOG_TABLE)
        df_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY_focused_ramanujan = (
            dyf.toDF()
            .select(
                "NISS_CVG_CD",
                "NISS_CLASS_CD",
                "CLNDR_YR",
                "TTL_WRITTN_PREM_AMT",
                "TALLY",
                "SUM_PREM"
            )
        )
    except Exception as e:
        logger.error(f"Failed reading FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY from fallback source: {e}", exc_info=True)
        raise

# 5) SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL: registered staged DF -> run SQL override against temp view
try:
    # register the staged upstream dataframe as the bare view name the override expects
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_jovial_hopper.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
    sql_query = f"""
    select
        REC_DROP_RSN_DESC,
        NISS_TERR_CD,
        CLNDR_YR,
        CALL_YR,
        BI_LMT,
        CVG_AMT,
        REC_EXCPN_IND,
        TTL_WRITTN_PREM_AMT,
        CVG_EXPS_VAL,
        NISS_CVG_CD,
        NISS_CLASS_CD,
        SRC_CLM_NUM,
        SRC_CLM_UNIT_NUM
    from
        WRK_BIRP_NISS_APRM_DETL
    """
    logger.info("Running SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL against staged temp view")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_fierce_heisenberg = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# 6) SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_Exception: register staged DF and run override filtered for exceptions
try:
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_eager_tesla.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
    sql_query = f"""
    select
        REC_DROP_RSN_DESC,
        NISS_TERR_CD,
        CLNDR_YR,
        CALL_YR,
        BI_LMT,
        CVG_AMT,
        REC_EXCPN_IND,
        TTL_WRITTN_PREM_AMT,
        CVG_EXPS_VAL,
        NISS_CVG_CD,
        NISS_CLASS_CD,
        SRC_CLM_NUM,
        SRC_CLM_UNIT_NUM
    from
        WRK_BIRP_NISS_APRM_DETL
    where
        REC_EXCPN_IND = 'Y'
    """
    logger.info("Running SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_Exception against staged temp view")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_Exception_pensive_maxwell = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_Exception: {e}", exc_info=True)
    raise

# 7) SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL: register upstream staged DF and run SQL override
try:
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_nostalgic_planck.createOrReplaceTempView("WRK_BIRP_NISS_APRM_FINAL")
    sql_query = f"""
    select
        TTL_WRITTN_PREM_AMT,
        CLNDR_YR,
        CALL_YR,
        CVG_EXPS_VAL,
        NISS_CVG_CD,
        NISS_CLASS_CD
    from
        WRK_BIRP_NISS_APRM_FINAL
    """
    logger.info("Running SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL against staged temp view")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_dazzling_lovelace = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL: {e}", exc_info=True)
    raise

# 8) SQ_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY: register staged summary DF and run aggregate SQL override
try:
    df_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY_focused_ramanujan.createOrReplaceTempView("WRK_BIRP_NISS_APRM_SUMRY")
    sql_query = f"""
    select
        NISS_CVG_CD,
        NISS_CLASS_CD,
        CLNDR_YR,
        sum(TTL_WRITTN_PREM_AMT) as SUM_PREM,
        count(1) as TALLY,
        sum(CVG_EXPS_VAL) as SUM_CVG_EXPS_VAL
    from
        WRK_BIRP_NISS_APRM_SUMRY
    group by
        NISS_CVG_CD, NISS_CLASS_CD, CLNDR_YR
    """
    logger.info("Running SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY against staged temp view")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY_lucid_shannon = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY: {e}", exc_info=True)
    raise

# 9) EXP_GenErrReason: parse REC_DROP_RSN_DESC into semicolon-separated tokens and trim
try:
    logger.info("Transforming EXP_GenErrReason: extracting semicolon-separated error reason tokens from REC_DROP_RSN_DESC")
    df_EXP_GenErrReason_optimistic_lovelace = (
        df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_fierce_heisenberg
        .withColumn("REC_DROP_RSN_DESC_TRIM", trim(col("REC_DROP_RSN_DESC")))
        .withColumn("ERR_PARTS", split(col("REC_DROP_RSN_DESC_TRIM"), ';'))
        .withColumn("ERR_RSN_1", trim(col("ERR_PARTS").getItem(0)))
        .withColumn("ERR_RSN_2", trim(col("ERR_PARTS").getItem(1)))
        .withColumn("ERR_RSN_3", trim(col("ERR_PARTS").getItem(2)))
        # final normalized description: prefer first non-null token, else null
        .withColumn(
            "REC_DROP_RSN_DESC",
            when(col("ERR_RSN_1") != "", col("ERR_RSN_1")).when(col("ERR_RSN_2") != "", col("ERR_RSN_2")).otherwise(col("ERR_RSN_3"))
        )
        .drop("REC_DROP_RSN_DESC_TRIM", "ERR_PARTS")
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_GenErrReason: {e}", exc_info=True)
    raise

# 10) EXP_PASS_DETL: project/derive detail-level fields, reuse intermediates where needed
try:
    logger.info("Transforming EXP_PASS_DETL: projecting and deriving detail fields, joining GEN error tokens")
    # join the SQ base with the GEN error tokens on claim identifiers so the derived error reason columns are available
    df_joined = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_fierce_heisenberg.alias("sq").join(
        df_EXP_GenErrReason_optimistic_lovelace.select("SRC_CLM_NUM", "SRC_CLM_UNIT_NUM", "REC_DROP_RSN_DESC").alias("err"),
        on=[
            col("sq.SRC_CLM_NUM") == col("err.SRC_CLM_NUM"),
            col("sq.SRC_CLM_UNIT_NUM") == col("err.SRC_CLM_UNIT_NUM")
        ],
        how="left"
    )

    # compute intermediate cleaned numeric columns once
    df_intermediate = (
        df_joined
        .withColumn("o_NISS_TERR_CD", when((trim(col("NISS_TERR_CD")).isNull()) | (trim(col("NISS_TERR_CD")) == ""), lit("???")).otherwise(col("NISS_TERR_CD")))
        .withColumn("clean_BI_LMT", regexp_replace(trim(col("BI_LMT")), '[^0-9\.-]', ''))
        .withColumn("clean_CVG_AMT", regexp_replace(trim(col("CVG_AMT")), '[^0-9\.-]', ''))
        .withColumn("o_BI_LMT", when(col("clean_BI_LMT") == "", None).otherwise(col("clean_BI_LMT")))
        .withColumn("o_CVG_AMT", when(col("clean_CVG_AMT") == "", None).otherwise(col("clean_CVG_AMT")))
    )

    # final projection selecting every required output column explicitly
    df_EXP_PASS_DETL_careful_socrates = (
        df_intermediate.selectExpr(
            "sq.SRC_CLM_NUM as SRC_CLM_NUM",
            "sq.SRC_CLM_UNIT_NUM as SRC_CLM_UNIT_NUM",
            "o_NISS_TERR_CD as o_NISS_TERR_CD",
            "trim(sq.CLNDR_YR) as o_CLNDR_YR",
            "trim(sq.CALL_YR) as o_CALL_YR",
            "o_BI_LMT as o_BI_LMT",
            "o_CVG_AMT as o_CVG_AMT",
            "sq.TTL_WRITTN_PREM_AMT as TTL_WRITTN_PREM_AMT",
            "sq.CVG_EXPS_VAL as CVG_EXPS_VAL",
            "coalesce(err.REC_DROP_RSN_DESC, sq.REC_DROP_RSN_DESC) as REC_DROP_RSN_DESC",
            "sq.NISS_CVG_CD as NISS_CVG_CD",
            "sq.NISS_CLASS_CD as NISS_CLASS_CD"
        )
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_PASS_DETL: {e}", exc_info=True)
    raise

# 11) EXP_PASS_TRGT: projection for exception/target records
try:
    logger.info("Transforming EXP_PASS_TRGT: projecting exception target records and cleaning numeric fields")
    df_temp = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_Exception_pensive_maxwell
    df_temp2 = (
        df_temp
        .withColumn("o_CLNDR_YR", expr("substring(trim(CLNDR_YR),1,4)"))
        .withColumn("o_CALL_YR", expr("substring(trim(CALL_YR),1,4)"))
        .withColumn("o_BI_LMT", regexp_replace(trim(col("BI_LMT")), '[^0-9\.-]', ''))
        .withColumn("o_CVG_AMT", regexp_replace(trim(col("CVG_AMT")), '[^0-9\.-]', ''))
    )
    df_EXP_PASS_TRGT_heroic_nash = df_temp2.selectExpr(
        "SRC_CLM_NUM",
        "SRC_CLM_UNIT_NUM",
        "o_CLNDR_YR",
        "o_CALL_YR",
        "o_BI_LMT",
        "o_CVG_AMT",
        "REC_EXCPN_IND",
        "TTL_WRITTN_PREM_AMT",
        "CVG_EXPS_VAL",
        "NISS_CVG_CD",
        "NISS_CLASS_CD"
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_PASS_TRGT: {e}", exc_info=True)
    raise

# 12) EXP_defaults: reprojection of FINAL-level fields
try:
    logger.info("Transforming EXP_defaults: reprojecting final-level fields and performing trivial derived aliases")
    df_EXP_defaults_careful_turing = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_dazzling_lovelace.selectExpr(
        "TTL_WRITTN_PREM_AMT",
        "substring(trim(CLNDR_YR),1,4) as CLNDR_YR",
        "substring(trim(CALL_YR),1,4) as CALL_YR",
        "CVG_EXPS_VAL",
        "NISS_CVG_CD",
        "NISS_CLASS_CD"
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_defaults: {e}", exc_info=True)
    raise

# 13) EX_PASS_SUMRY: derive summary-level aliases and defaults
try:
    logger.info("Transforming EX_PASS_SUMRY: producing summary-level aliases and defaults")
    df_EX_PASS_SUMRY_determined_turing = (
        df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_SUMRY_lucid_shannon
        .withColumn("o_CLNDR_YR", expr("substring(trim(CLNDR_YR),1,4)"))
        .withColumn("o_NISS_CVG_CD", when((trim(col("NISS_CVG_CD")).isNull()) | (trim(col("NISS_CVG_CD")) == ""), lit("UNK")).otherwise(col("NISS_CVG_CD")))
        .withColumn("o_NISS_CLASS_CD", when((trim(col("NISS_CLASS_CD")).isNull()) | (trim(col("NISS_CLASS_CD")) == ""), lit("UNK")).otherwise(col("NISS_CLASS_CD")))
        .select(
            "o_CLNDR_YR",
            "o_NISS_CVG_CD",
            "o_NISS_CLASS_CD",
            "SUM_PREM",
            "TALLY",
            "SUM_CVG_EXPS_VAL"
        )
    )
except Exception as e:
    logger.error(f"Failed transforming EX_PASS_SUMRY: {e}", exc_info=True)
    raise

# 14) Output: FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Detail (flat file)
try:
    logger.info("Writing flat file target FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Detail via pandas to PM_TARGET_FILE_DIR")
    pdf = df_EXP_PASS_DETL_careful_socrates.toPandas()
    pdf.to_csv(f"{PM_TARGET_FILE_DIR}/{OUTPUT_FILE_PREMRPT1_DET}", index=False, mode='w')
    df_FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Detail_jovial_nash = df_EXP_PASS_DETL_careful_socrates
except Exception as e:
    logger.error(f"Failed writing flat file FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Detail: {e}", exc_info=True)
    raise

# 15) Output: FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptXcpn (flat file)
try:
    logger.info("Writing flat file target FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptXcpn via pandas to PM_TARGET_FILE_DIR")
    pdf = df_EXP_PASS_TRGT_heroic_nash.toPandas()
    pdf.to_csv(f"{PM_TARGET_FILE_DIR}/{OUTPUT_FILE_PREMRPT_EXC}", index=False, mode='w')
    df_FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptXcpn_humble_curie = df_EXP_PASS_TRGT_heroic_nash
except Exception as e:
    logger.error(f"Failed writing flat file FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptXcpn: {e}", exc_info=True)
    raise

# 16) EXP_PASS_FINAL_Csv: finalize CSV layout and formatting
try:
    logger.info("Transforming EXP_PASS_FINAL_Csv: final CSV formatting and ordered columns")
    df_temp = df_EXP_defaults_careful_turing
    df_temp2 = (
        df_temp
        .withColumn("o_CLNDR_YR", expr("substring(trim(CLNDR_YR),1,4)"))
        .withColumn("o_REG_PRD_YR", expr("substring(trim(CLNDR_YR),1,4)"))
        .withColumn("o_NISS_CVG_CD", when((trim(col("NISS_CVG_CD")).isNull()) | (trim(col("NISS_CVG_CD")) == ""), lit("UNK")).otherwise(col("NISS_CVG_CD")))
        .withColumn("o_NISS_TERR_CD", when((trim(col("NISS_TERR_CD")).isNull()) | (trim(col("NISS_TERR_CD")) == ""), lit("???")).otherwise(col("NISS_TERR_CD")))
        .withColumn("o_NISS_CLASS_CD", when((trim(col("NISS_CLASS_CD")).isNull()) | (trim(col("NISS_CLASS_CD")) == ""), lit("UNK")).otherwise(col("NISS_CLASS_CD")))
        .withColumn("o_TTL_WRITTN_PREM_AMT", format_string('%.2f', round(col("TTL_WRITTN_PREM_AMT"),2)))
    )
    df_EXP_PASS_FINAL_Csv_tender_euclid = df_temp2.select(
        "o_CLNDR_YR",
        "o_REG_PRD_YR",
        "o_NISS_CVG_CD",
        "o_NISS_CLASS_CD",
        "o_NISS_TERR_CD",
        "o_TTL_WRITTN_PREM_AMT",
        "CVG_EXPS_VAL"
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_PASS_FINAL_Csv: {e}", exc_info=True)
    raise

# 17) EXP_PASS_FINAL_Txt: finalize fixed-width/text layout (formatted numeric strings, paddings)
try:
    logger.info("Transforming EXP_PASS_FINAL_Txt: final text/fixed-width formatting and padded numeric strings")
    df_temp = df_EXP_defaults_careful_turing
    df_temp2 = (
        df_temp
        .withColumn("o_CLNDR_YR", expr("substring(trim(CLNDR_YR),1,4)"))
        .withColumn("o_REG_PRD_YR", expr("substring(trim(CLNDR_YR),1,4)"))
        .withColumn("o_CVG_EXPS_VAL_fmt", format_string('%.2f', round(col("CVG_EXPS_VAL"),2)))
        .withColumn("o_TTL_WRITTN_PREM_AMT_fmt", lpad(regexp_replace(format_string('%.0f', round(col("TTL_WRITTN_PREM_AMT"),0)), '\\.', ''), 12, '0'))
    )
    df_EXP_PASS_FINAL_Txt_nostalgic_pasteur = df_temp2.select(
        "o_CLNDR_YR",
        "o_REG_PRD_YR",
        "o_TTL_WRITTN_PREM_AMT_fmt",
        "o_CVG_EXPS_VAL_fmt",
        "NISS_CVG_CD",
        "NISS_CLASS_CD"
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_PASS_FINAL_Txt: {e}", exc_info=True)
    raise

# 18) Output: FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Summary (flat file)
try:
    logger.info("Writing flat file target FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Summary via pandas to PM_TARGET_FILE_DIR")
    pdf = df_EX_PASS_SUMRY_determined_turing.toPandas()
    pdf.to_csv(f"{PM_TARGET_FILE_DIR}/{OUTPUT_FILE_PREMRPT3_SUM}", index=False, mode='w')
    df_FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Summary_amazing_hopper = df_EX_PASS_SUMRY_determined_turing
except Exception as e:
    logger.error(f"Failed writing flat file FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Summary: {e}", exc_info=True)
    raise

# 19) Output: FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Csv (flat file)
try:
    logger.info("Writing flat file target FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Csv via pandas to PM_TARGET_FILE_DIR")
    pdf = df_EXP_PASS_FINAL_Csv_tender_euclid.toPandas()
    pdf.to_csv(f"{PM_TARGET_FILE_DIR}/{OUTPUT_FILE_PREMRPT2_FNLCsv}", index=False, mode='w')
    df_FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Csv_magical_faraday = df_EXP_PASS_FINAL_Csv_tender_euclid
except Exception as e:
    logger.error(f"Failed writing flat file FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Csv: {e}", exc_info=True)
    raise

# 20) Output: FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Txt (flat file)
try:
    logger.info("Writing flat file target FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Txt via pandas to PM_TARGET_FILE_DIR")
    pdf = df_EXP_PASS_FINAL_Txt_nostalgic_pasteur.toPandas()
    # For fixed-width/text output we use a simple CSV write (caller should confirm exact fixed-width spec)
    pdf.to_csv(f"{PM_TARGET_FILE_DIR}/{OUTPUT_FILE_PREMRPT2_FnlTxt}", index=False, mode='w', sep='|')
    df_FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Txt_calm_dirac = df_EXP_PASS_FINAL_Txt_nostalgic_pasteur
except Exception as e:
    logger.error(f"Failed writing flat file FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptExt_Final_Txt: {e}", exc_info=True)
    raise


job.commit()
