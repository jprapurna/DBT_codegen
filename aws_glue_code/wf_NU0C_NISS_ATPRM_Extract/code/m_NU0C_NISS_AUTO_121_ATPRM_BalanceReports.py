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

from pyspark.sql.functions import expr, col, when, lit, trim, substring

# Top-of-script placeholders for environment / mapping-parameter values
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"
PM_TARGET_FILE_DIR = "REPLACE_WITH_PM_TARGET_FILE_DIR"
OUTPUT_FILENAME = "REPLACE_WITH_OUTPUT_FILENAME"

# ---------------------------------------------------------------------
# FDR_LIB_WRK_BIRP_NISS_APRM_DETL (Source)
# Attempt S3-first read of staged parquet path, fall back to Glue Catalog
# Projects: CLNDR_YR, NISS_CMPNY_CD, ST_NM, TTL_WRITTN_PREM_AMT
# ---------------------------------------------------------------------
try:
    logger.info("Attempting to read staged parquet for WRK_BIRP_NISS_APRM_DETL from S3")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_relaxed_socrates = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
        .selectExpr(
            "CLNDR_YR",
            "NISS_CMPNY_CD",
            "ST_NM",
            "TTL_WRITTN_PREM_AMT"
        )
    )
except Exception as e_s3:
    logger.warning(f"Staged parquet for WRK_BIRP_NISS_APRM_DETL not found in S3, falling back to Glue Catalog: {e_s3}")
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_relaxed_socrates = (
            dyf.toDF().selectExpr(
                "CLNDR_YR",
                "NISS_CMPNY_CD",
                "ST_NM",
                "TTL_WRITTN_PREM_AMT"
            )
        )
    except Exception as e_catalog:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog: {e_catalog}", exc_info=True)
        raise

# ---------------------------------------------------------------------
# FDR_LIB_WRK_BIRP_NISS_APRM_FINAL (Source)
# Attempt S3-first read of staged parquet path, fall back to Glue Catalog
# Projects: TTL_WRITTN_PREM_AMT
# ---------------------------------------------------------------------
try:
    logger.info("Attempting to read staged parquet for WRK_BIRP_NISS_APRM_FINAL from S3")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_stoic_mendel = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_FINAL/")
        .selectExpr(
            "CLNDR_YR",
            "NISS_CMPNY_CD",
            "ST_NM",
            "TTL_WRITTN_PREM_AMT"
        )
    )
except Exception as e_s3_final:
    logger.warning(f"Staged parquet for WRK_BIRP_NISS_APRM_FINAL not found in S3, falling back to Glue Catalog: {e_s3_final}")
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_FINAL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_FINAL")
        df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_stoic_mendel = (
            dyf.toDF().selectExpr(
                "CLNDR_YR",
                "NISS_CMPNY_CD",
                "ST_NM",
                "TTL_WRITTN_PREM_AMT"
            )
        )
    except Exception as e_catalog_final:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_FINAL from Glue Catalog: {e_catalog_final}", exc_info=True)
        raise

# ---------------------------------------------------------------------
# SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL (Application Source Qualifier)
# This SQ has a SQL override that references the two staged WRK_ tables.
# Register upstream staged dataframes as temp views and run rewritten SQL
# Outputs: CLNDR_YR, NISS_CMPNY_CD, ST_NM, DET_PREM_AMT, DROP_PREM_AMT, FNL_PREM_AMT
# ---------------------------------------------------------------------
try:
    # register the staged DFS as temp views named after their real table names
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_relaxed_socrates.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_FINAL_stoic_mendel.createOrReplaceTempView("WRK_BIRP_NISS_APRM_FINAL")

    sql_query = f"""select
    coalesce(a.CLNDR_YR, b.CLNDR_YR) as CLNDR_YR,
    coalesce(a.NISS_CMPNY_CD, b.NISS_CMPNY_CD) as NISS_CMPNY_CD,
    coalesce(a.ST_NM, b.ST_NM) as ST_NM,
    a.DET_PREM_AMT as DET_PREM_AMT,
    (coalesce(a.DET_PREM_AMT, 0) - coalesce(b.FNL_PREM_AMT, 0)) as DROP_PREM_AMT,
    b.FNL_PREM_AMT as FNL_PREM_AMT
from
    (
        select CLNDR_YR, NISS_CMPNY_CD, ST_NM, sum(TTL_WRITTN_PREM_AMT) as DET_PREM_AMT
        from WRK_BIRP_NISS_APRM_DETL
        group by CLNDR_YR, NISS_CMPNY_CD, ST_NM
    ) a
full outer join
    (
        select CLNDR_YR, NISS_CMPNY_CD, ST_NM, sum(TTL_WRITTN_PREM_AMT) as FNL_PREM_AMT
        from WRK_BIRP_NISS_APRM_FINAL
        group by CLNDR_YR, NISS_CMPNY_CD, ST_NM
    ) b
on
    a.CLNDR_YR = b.CLNDR_YR
    and a.NISS_CMPNY_CD = b.NISS_CMPNY_CD
    and a.ST_NM = b.ST_NM
"""

    logger.info("Executing SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL against staged temp views")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_calm_heisenberg = spark.sql(sql_query)
except Exception as e_sq:
    logger.error(f"Failed executing SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL: {e_sq}", exc_info=True)
    raise

# ---------------------------------------------------------------------
# EXP_DeriveBalanaceIndicator (Expression)
# Project passthroughs and compute o_CLNDR_YR, intermediate v_BAL_DIFF,
# expose BAL_DIFF and BAL_IND
# Inputs: NISS_CMPNY_CD, ST_NM, DET_PREM_AMT, DROP_PREM_AMT, FNL_PREM_AMT, CLNDR_YR
# ---------------------------------------------------------------------
try:
    logger.info("Applying EXP_DeriveBalanaceIndicator expression transformations")
    # First project explicit passthrough columns and derive o_CLNDR_YR
    df_EXP_step1 = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_calm_heisenberg.selectExpr(
        "NISS_CMPNY_CD",
        "ST_NM",
        "DET_PREM_AMT",
        "DROP_PREM_AMT",
        "FNL_PREM_AMT",
        "substring(trim(CLNDR_YR), 3, 2) as o_CLNDR_YR"
    )

    # Create intermediate v_BAL_DIFF
    df_EXP_step2 = df_EXP_step1.withColumn("v_BAL_DIFF", expr("DET_PREM_AMT - DROP_PREM_AMT - FNL_PREM_AMT"))

    # Expose BAL_DIFF and BAL_IND (referencing the intermediate alias)
    df_EXP_DeriveBalanaceIndicator_jovial_schrodinger = (
        df_EXP_step2
        .withColumn("BAL_DIFF", col("v_BAL_DIFF"))
        .withColumn("BAL_IND", when(col("v_BAL_DIFF") == 0, lit("Y")).otherwise(lit("N")))
        .select(
            "NISS_CMPNY_CD",
            "ST_NM",
            "o_CLNDR_YR",
            "DET_PREM_AMT",
            "DROP_PREM_AMT",
            "FNL_PREM_AMT",
            "BAL_DIFF",
            "BAL_IND"
        )
    )
except Exception as e_exp:
    logger.error(f"Failed applying EXP_DeriveBalanaceIndicator: {e_exp}", exc_info=True)
    raise

# ---------------------------------------------------------------------
# FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptBal2 (Output: flat file target)
# Convert final Spark dataframe to pandas and write to PM_TARGET_FILE_DIR/OUTPUT_FILENAME
# ---------------------------------------------------------------------
try:
    logger.info("Converting final dataframe to pandas for flat-file output and writing to target directory")
    pandas_df = df_EXP_DeriveBalanaceIndicator_jovial_schrodinger.toPandas()
    output_path = f"{PM_TARGET_FILE_DIR.rstrip('/')}/{OUTPUT_FILENAME.lstrip('/')}"

    # choose writer by extension
    if OUTPUT_FILENAME.lower().endswith('.csv'):
        pandas_df.to_csv(output_path, mode='w', index=False)
    elif OUTPUT_FILENAME.lower().endswith('.xlsx') or OUTPUT_FILENAME.lower().endswith('.xls'):
        pandas_df.to_excel(output_path, index=False)
    else:
        # default to CSV if extension is unknown
        pandas_df.to_csv(output_path, mode='w', index=False)

    # expose the output df variable name expected by downstream (even though it's a file write)
    df_FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptBal2_nice_bohr = df_EXP_DeriveBalanaceIndicator_jovial_schrodinger
except Exception as e_out:
    logger.error(f"Failed writing flat-file output for FDR_LIB_ff_BIRP_NU0C_NISS_ATPRM_RptBal2: {e_out}", exc_info=True)
    raise


job.commit()
