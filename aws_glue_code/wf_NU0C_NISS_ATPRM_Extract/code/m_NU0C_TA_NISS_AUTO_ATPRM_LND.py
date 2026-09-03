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

from pyspark.sql.functions import col, expr, when, trim, lit, broadcast, row_number, sha2, regexp_replace, substring
from pyspark.sql.window import Window

# Placeholder constants for mapping parameters and environment values
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
PM_LOOKUP_FILE_DIR = "REPLACE_WITH_PM_LOOKUP_FILE_DIR"
LOOKUP_FILENAME_ff_NISS_STATE = "REPLACE_WITH_LOOKUP_FILENAME_ff_NISS_STATE.csv"
SOURCE_TABLE = "REPLACE_WITH_SOURCE_TABLE"

# -----------------------------------------------------------------------------
# Node: Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND (Source)
# Note: This source is bypassed by a downstream SQL override; keep a lightweight
# assignment so downstream metadata references resolve in the generated code.
# The actual JDBC read is performed by the consuming Application Source Qualifier.
# -----------------------------------------------------------------------------
try:
    logger.info("Registering placeholder for Source: Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND (bypassed by SQ)")
    # Bypassed source placeholder; the consuming SQ performs the JDBC read instead.
    df_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND_humble_babbage = None
except Exception as e:
    logger.error(f"Failed initializing placeholder for Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND (Application Source Qualifier)
# Rule: SQL Override present; default (non-staged) case -> run override against Snowflake via JDBC
# Keep a lineage comment referencing the upstream Source node above the SQL.
# -----------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND (bypassed — SQL Override below reads it directly)
# (referenced placeholder variable from upstream source for lineage)
_ = df_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND_humble_babbage

sql_query = f"""select
    -- project the ports needed downstream; aliases match the Informatica port names consumed later
    i_GRGNG_ZIP,
    ST_CD,
    ST_NM as i_ST_NM,
    i_GA_ADDED_AT_FAULT_IND,
    i_ST_ABBR,
    ACCTNG_LOB,
    -- include any other passthrough columns the mapping expects; replace SOURCE_TABLE below
    *
from
    {SOURCE_TABLE}
"""

try:
    logger.info("Reading SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND from Snowflake via JDBC override query")
    df_SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND_lucid_lovelace = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(f"Failed reading SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND from Snowflake: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: EXP_PASS_THROUGH (Expression) - pure passthrough projection
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_PASS_THROUGH projection")
    # Explicitly list passthrough columns rather than using '*'. We project the known ports
    # referenced downstream; include a conservative set and fall back to existing columns.
    df_EXP_PASS_THROUGH_reverent_dirac = df_SQ_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND_lucid_lovelace.selectExpr(
        "i_GRGNG_ZIP",
        "ST_CD",
        "i_ST_NM",
        "i_GA_ADDED_AT_FAULT_IND",
        "i_ST_ABBR",
        "ACCTNG_LOB",
        "*"
    )
except Exception as e:
    logger.error(f"Failed EXP_PASS_THROUGH projection: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: EXPTRANS (Expression) - derive GRGNG_ZIP_5 and IFARMERS_STATE_CD from ST_CD
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXPTRANS transformations (GRGNG_ZIP_5, v_FARMERS_STATE_CD -> IFARMERS_STATE_CD)")
    # First, ensure required base columns are present; project the necessary input columns explicitly
    df_tmp_exp = df_EXP_PASS_THROUGH_reverent_dirac.select(
        col("i_GRGNG_ZIP"),
        col("ST_CD"),
        col("i_ST_NM"),
        col("i_GA_ADDED_AT_FAULT_IND"),
        col("i_ST_ABBR"),
        col("ACCTNG_LOB")
    )

    # Compute GRGNG_ZIP_5 according to DECODE-like logic: NULL/blank/'0' -> '00000', else trimmed value
    df_tmp_exp = df_tmp_exp.withColumn(
        "GRGNG_ZIP_5",
        when(
            (col("i_GRGNG_ZIP").isNull()) | (trim(col("i_GRGNG_ZIP")) == "") | (trim(col("i_GRGNG_ZIP")) == "0"),
            lit("00000"),
        ).otherwise(trim(col("i_GRGNG_ZIP")))
    )

    # Create intermediary v_FARMERS_STATE_CD then integer IFARMERS_STATE_CD (chain to respect alias scoping)
    df_tmp_exp = df_tmp_exp.withColumn(
        "v_FARMERS_STATE_CD",
        when(col("ST_CD") == "#", lit("00")).otherwise(col("ST_CD"))
    )

    df_tmp_exp = df_tmp_exp.withColumn("IFARMERS_STATE_CD", expr("cast(v_FARMERS_STATE_CD as int)"))

    df_EXPTRANS_magical_noether = df_tmp_exp
except Exception as e:
    logger.error(f"Failed EXPTRANS transformations: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: LKP_ff_REF_NISS_STATE_CD (Lookup) - broadcast join to flat-file lookup
# -----------------------------------------------------------------------------
try:
    logger.info("Reading lookup file ff_NISS_STATE and joining to produce NISS_STATE_CODE")
    lookup_path = f"{PM_LOOKUP_FILE_DIR.rstrip('/')}/{LOOKUP_FILENAME_ff_NISS_STATE}"
    # read the lookup file (assumed small) - CSV with header expected
    df_lookup_ff_NISS_STATE = spark.read.option("header", "true").csv(lookup_path)

    # broadcast-join on FARMERS_STATE_NAME = i_ST_NM (i_ST_NM originates from ST_NM)
    # The lookup's output column is expected to be NISS_STATE_CODE
    df_LKP_ff_REF_NISS_STATE_CD_focused_leibniz = (
        df_EXPTRANS_magical_noether.join(
            broadcast(df_lookup_ff_NISS_STATE),
            (col("FARMERS_STATE_NAME") == col("i_ST_NM")),
            how="left"
        )
        # keep all original columns plus the lookup column (may be null when no match)
    )
except Exception as e:
    logger.error(f"Failed lookup join for LKP_ff_REF_NISS_STATE_CD: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: EXPTRANS1 (Expression) - use lookup result, derive flags and ST_ABBR handling
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXPTRANS1 per-port derivations and passthroughs")
    df_tmp = df_LKP_ff_REF_NISS_STATE_CD_focused_leibniz

    # Derive NISS_STATE_CODE from lookup result; when NULL/blank -> '?'
    df_tmp = df_tmp.withColumn(
        "NISS_STATE_CODE",
        when((col("NISS_STATE_CODE").isNull()) | (trim(col("NISS_STATE_CODE")) == ""), lit("?")).otherwise(col("NISS_STATE_CODE"))
    )

    # Derive GA_ADDED_AT_FAULT_IND: IIF(i_GA_ADDED_AT_FAULT_IND='1','Y','N')
    df_tmp = df_tmp.withColumn(
        "GA_ADDED_AT_FAULT_IND",
        when(col("i_GA_ADDED_AT_FAULT_IND") == "1", lit("Y")).otherwise(lit("N"))
    )

    # Derive ST_ABBR from i_ST_ABBR: NULL/blank -> '?', else trimmed value
    df_tmp = df_tmp.withColumn(
        "ST_ABBR",
        when((col("i_ST_ABBR").isNull()) | (trim(col("i_ST_ABBR")) == ""), lit("?")).otherwise(trim(col("i_ST_ABBR")))
    )

    # Set EXPS_VAL_ROLLED = 0
    df_tmp = df_tmp.withColumn("EXPS_VAL_ROLLED", lit(0))

    # For any columns that would have come from a missing third input, produce NULLs if referenced later.
    # (The plan notes a missing mapping input; ensure expected column names exist as NULL to avoid runtime errors.)
    # Example placeholder for a missing column that might be referenced later:
    if "POSSIBLE_MISSING_COL" not in df_tmp.columns:
        df_tmp = df_tmp.withColumn("POSSIBLE_MISSING_COL", lit(None))

    # Preserve/pass-through other columns explicitly where reasonable
    df_EXPTRANS1_tender_babbage = df_tmp
except Exception as e:
    logger.error(f"Failed EXPTRANS1 transformations: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: EXPTRANS2 (Expression) - final derivations and mapping-audit NULLs
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXPTRANS2 final expressions and audit-null assignments")
    df_tmp2 = df_EXPTRANS1_tender_babbage

    # Derive o_ANNUAL_STMT_LOB = substr(trim(ACCTNG_LOB),1,3)
    df_tmp2 = df_tmp2.withColumn("o_ANNUAL_STMT_LOB", substring(trim(col("ACCTNG_LOB")), 1, 3))

    # Derive/clean NISS_TERR_CD if present; otherwise leave as NULL
    if "NISS_TERR_CD" in df_tmp2.columns:
        df_tmp2 = df_tmp2.withColumn(
            "NISS_TERR_CD",
            when((col("NISS_TERR_CD").isNull()) | (trim(col("NISS_TERR_CD")) == ""), lit(None)).otherwise(trim(col("NISS_TERR_CD")))
        )
    else:
        df_tmp2 = df_tmp2.withColumn("NISS_TERR_CD", lit(None))

    # Informatica mapping/system audit ports have no Glue equivalent -> emit as literal NULLs
    df_tmp2 = df_tmp2.withColumn("MAPPING_NAME", lit(None))
    df_tmp2 = df_tmp2.withColumn("FOLDER_NAME", lit(None))
    df_tmp2 = df_tmp2.withColumn("WORKFLOW_NAME", lit(None))

    df_EXPTRANS2_clever_schrodinger = df_tmp2
except Exception as e:
    logger.error(f"Failed EXPTRANS2 transformations: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Node: Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND1 (Output)
# Rule: write to S3 as parquet (overwrite). Also, generate surrogate key NISS_APRM_LND_SK
# from a missing Sequence Generator via row_number() over Window.orderBy(lit(1)).
# -----------------------------------------------------------------------------
try:
    logger.info("Preparing final target dataset and generating surrogate key NISS_APRM_LND_SK")

    # Explicitly select all output columns (omit mapping-audit columns that were produced as NULL above)
    # Note: The surrogate key must be appended after the projection per the Sequence Generator rule.
    df_selected = df_EXPTRANS2_clever_schrodinger.select(
        # business columns
        col("GRGNG_ZIP_5"),
        col("IFARMERS_STATE_CD"),
        col("NISS_STATE_CODE"),
        col("GA_ADDED_AT_FAULT_IND"),
        col("ST_ABBR"),
        col("EXPS_VAL_ROLLED"),
        col("o_ANNUAL_STMT_LOB"),
        col("NISS_TERR_CD"),
        col("ACCTNG_LOB"),
        # any placeholders preserved earlier
        col("POSSIBLE_MISSING_COL"),
        # mapping audit columns intentionally left as NULLs (already present as MAPPING_NAME, FOLDER_NAME, WORKFLOW_NAME)
        col("MAPPING_NAME"),
        col("FOLDER_NAME"),
        col("WORKFLOW_NAME")
    )

    # Generate surrogate key using row_number over a constant ordering. This forces a global shuffle
    # and guarantees gap-free sequential values starting at 1. Review performance for very large inputs.
    window_spec = Window.orderBy(lit(1))
    df_with_sk = df_selected.withColumn("NISS_APRM_LND_SK", row_number().over(window_spec))

    # Assign to the node's output dataframe variable
    df_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND1_stoic_faraday = df_with_sk

    # write intermediate WRK_ table as parquet to S3 (overwrite)
    logger.info("Writing WRK_BIRP_TA_NISS_NU0C_APRM_LND1 to S3 as parquet (overwrite)")
    df_Shortcut_to_WRK_BIRP_TA_NISS_NU0C_APRM_LND1_stoic_faraday.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_TA_NISS_NU0C_APRM_LND1/"
    )
except Exception as e:
    logger.error(f"Failed preparing or writing WRK_BIRP_TA_NISS_NU0C_APRM_LND1 to S3: {e}", exc_info=True)
    raise


job.commit()
