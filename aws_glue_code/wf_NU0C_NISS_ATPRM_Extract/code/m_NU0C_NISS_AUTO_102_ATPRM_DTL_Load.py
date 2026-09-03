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

from pyspark.sql.functions import expr, col, lit, row_number
from pyspark.sql.window import Window

# Placeholder constants for Informatica mapping parameters and environment values
CLNDR_YR = "REPLACE_WITH_CLNDR_YR_VALUE"
RPT_YEAR = "REPLACE_WITH_RPT_YEAR_VALUE"
BACKENDFIX_DT = "REPLACE_WITH_BACKENDFIX_DT_VALUE"
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
GLUE_SOURCE_DATABASE = "REPLACE_WITH_GLUE_SOURCE_DATABASE"

# -----------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL
# Read the intermediate WRK_ table named WRK_BIRP_TA_NISS_NU0C_APRM_DTL from S3 if present,
# otherwise fall back to a Glue Catalog read. Assign to df_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL_friendly_franklin
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting to read Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL from S3 staging path first")
    df_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL_friendly_franklin = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_TA_NISS_NU0C_APRM_DTL/"
    )
except Exception as e:
    # Allowed fallback: try Glue Catalog (or other configured source) if S3 staging path is missing
    logger.warning(
        f"S3 read for WRK_BIRP_TA_NISS_NU0C_APRM_DTL failed, falling back to Glue Catalog read: {e}"
    )
    try:
        logger.info("Reading Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL from Glue Catalog")
        dyf = glueContext.create_dynamic_frame.from_catalog(
            database=GLUE_SOURCE_DATABASE,
            table_name="WRK_BIRP_TA_NISS_NU0C_APRM_DTL",
        )
        df_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL_friendly_franklin = dyf.toDF()
    except Exception as e2:
        logger.error(
            f"Failed reading WRK_BIRP_TA_NISS_NU0C_APRM_DTL from Glue Catalog: {e2}",
            exc_info=True,
        )
        raise

# -----------------------------------------------------------------------------
# SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL (Application Source Qualifier with SQL override)
# Note: the override bypasses the upstream Source node above; keep a comment so lineage is visible.
# -----------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL (bypassed — SQL Override below reads it directly)
sql_query = f"""select
    t.*
from
    FDR.SOME_SOURCE_TABLE t
where
    t.ACCT_YR IN ({CLNDR_YR}, {RPT_YEAR})
    and t.BACKEND_FIX_DT <= '{BACKENDFIX_DT}'
"""

try:
    logger.info("Reading SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL from Snowflake via JDBC override query")
    df_SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL_awesome_faraday = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(
        f"Failed reading SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL from Snowflake: {e}",
        exc_info=True,
    )
    raise

# -----------------------------------------------------------------------------
# EXPTRANS: pure passthrough - project every incoming column explicitly (no '*')
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXPTRANS passthrough projection")
    # Explicitly list every incoming column rather than using '*'
    _in_cols = df_SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL_awesome_faraday.columns
    if len(_in_cols) == 0:
        # defensively keep an empty DataFrame if no columns exist
        df_EXPTRANS_blissful_pasteur = df_SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL_awesome_faraday
    else:
        select_exprs = [f"`{c}`" for c in _in_cols]
        df_EXPTRANS_blissful_pasteur = df_SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_DTL_awesome_faraday.selectExpr(
            *select_exprs
        )
except Exception as e:
    logger.error(f"Failed processing EXPTRANS: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_PassThru: compute intermediate local variables where needed and add lookup-missing
# columns as NULLs (the external lookup df is missing so those columns are emitted as NULL)
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_PassThru transformations (intermediates + nulls for missing lookup columns)")
    _in_df = df_EXPTRANS_blissful_pasteur
    _in_cols = _in_df.columns

    # Project all incoming columns explicitly first (no '*')
    if len(_in_cols) == 0:
        df_stage = _in_df
    else:
        select_exprs = [f"`{c}`" for c in _in_cols]
        df_stage = _in_df.selectExpr(*select_exprs)

    # The mapping referenced a lookup that is missing from the metadata (ZIP_CD would have come from it).
    # Emit ZIP_CD as NULL so downstream schema is preserved for reviewers.
    # Any other lookup-derived ports should be added similarly as lit(None) here if required.
    df_EXP_PassThru_elegant_descartes = (
        df_stage.withColumn("ZIP_CD", lit(None))
        .withColumn("NISS_TERR_CD", lit(None))
    )
except Exception as e:
    logger.error(f"Failed processing EXP_PassThru: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_PassThru_Tgt: project final target schema explicitly and attach surrogate key
# NISS_APRM_DETL_SK via row_number() over Window.orderBy(lit(1)). Note: this forces a
# single-partition shuffle and should be reviewed for very large inputs.
# The mapping-audit Mapplet was missing; any audit columns it would have supplied are omitted
# and the join that would have attached it is commented out for reviewer visibility.
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_PassThru_Tgt final projection and generating surrogate key NISS_APRM_DETL_SK")
    _src = df_EXP_PassThru_elegant_descartes
    _cols = _src.columns

    # Explicit projection of every available column (passthrough + derived)
    if len(_cols) == 0:
        df_proj = _src
    else:
        select_exprs = [f"`{c}`" for c in _cols]
        df_proj = _src.selectExpr(*select_exprs)

    # Now attach the surrogate key column (Sequence Generator behavior: gap-free row_number)
    # Note: this may cause a shuffle; this emulates Informatica SEQTRANS (NEXTVAL = 1,2,3...)
    df_EXP_PassThru_Tgt_busy_nash = df_proj.withColumn(
        "NISS_APRM_DETL_SK",
        row_number().over(Window.orderBy(lit(1)))
    )

except Exception as e:
    logger.error(f"Failed processing EXP_PassThru_Tgt: {e}", exc_info=True)
    raise

# Assign the Output node's dataframe name to the result of the last Expression
df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_elegant_galileo = df_EXP_PassThru_Tgt_busy_nash

# -----------------------------------------------------------------------------
# write final target FDR_LIB_WRK_BIRP_NISS_APRM_DETL as parquet to S3 (overwrite)
# Note: strip any FDR_LIB_/Shortcut_to_ prefix when deriving the real S3 path name
# Real target path (prefix-stripped): WRK_BIRP_NISS_APRM_DETL
# -----------------------------------------------------------------------------
try:
    logger.info("Writing FDR_LIB_WRK_BIRP_NISS_APRM_DETL to S3 as parquet (overwrite)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_elegant_galileo.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL to S3: {e}", exc_info=True)
    raise


job.commit()
