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

from pyspark.sql import functions as F
from pyspark.sql.functions import broadcast
from pyspark.sql.window import Window
from pyspark.sql.types import StructType

# Top-of-script placeholder constants
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
LOOKUP_NISS_STATE_FILE = "REPLACE_WITH_LOOKUP_NISS_STATE_FILE_PATH"

# -----------------------------------------------------------------------------
# Source placeholders for SQ-bypassed upstream tables
# These sources are referenced by the SQ override below but in the SQ's
# non-staged (default) mode the override performs the JDBC read. To keep
# variable names available for lineage and to satisfy downstream references
# we create empty placeholder DataFrames for each bypassed Source node.
# -----------------------------------------------------------------------------
try:
    logger.info("Creating placeholder for df_FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL_friendly_newton (bypassed by SQ)")
    df_FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL_friendly_newton = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL_friendly_newton: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_SOI_loving_pascal (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_SOI_loving_pascal = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_SOI_loving_pascal: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_PLCY_ENH_blissful_noether (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_PLCY_ENH_blissful_noether = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_PLCY_ENH_blissful_noether: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_PLCY_keen_leibniz (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_PLCY_keen_leibniz = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_PLCY_keen_leibniz: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_CVG_blissful_darwin (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_CVG_blissful_darwin = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_CVG_blissful_darwin: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_RATED_GEO_keen_rutherford (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_RATED_GEO_keen_rutherford = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_RATED_GEO_keen_rutherford: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_CVG_ENH_modest_bohr (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_CVG_ENH_modest_bohr = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_CVG_ENH_modest_bohr: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_FARMR_GEO_ST_reverent_hume (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_FARMR_GEO_ST_reverent_hume = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_FARMR_GEO_ST_reverent_hume: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_MINI_PLCY_loving_planck (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_MINI_PLCY_loving_planck = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_MINI_PLCY_loving_planck: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_DT_adoring_feynman (bypassed by SQ)")
    df_FDR_LIB_DIM_DT_adoring_feynman = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_DT_adoring_feynman: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_MINI_CVG_jovial_bohr (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_MINI_CVG_jovial_bohr = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_MINI_CVG_jovial_bohr: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_SOI_ENH_cool_hawking (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_SOI_ENH_cool_hawking = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_SOI_ENH_cool_hawking: {e}", exc_info=True)
    raise

try:
    logger.info("Creating placeholder for df_FDR_LIB_DIM_AG_MINI_SOI_happy_hume (bypassed by SQ)")
    df_FDR_LIB_DIM_AG_MINI_SOI_happy_hume = spark.createDataFrame(sc.emptyRDD(), StructType([]))
except Exception as e:
    logger.error(f"Failed creating placeholder for df_FDR_LIB_DIM_AG_MINI_SOI_happy_hume: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Application Source Qualifier: execute SQL override against Snowflake via JDBC
# Sources referenced above are bypassed in the default (non-staged) path; list
# them here for lineage traceability.
# Source: FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL, FDR_LIB_DIM_AG_SOI,
# FDR_LIB_DIM_AG_PLCY_ENH, FDR_LIB_DIM_AG_PLCY, FDR_LIB_DIM_AG_CVG,
# FDR_LIB_DIM_AG_RATED_GEO, FDR_LIB_DIM_AG_CVG_ENH, FDR_LIB_DIM_AG_FARMR_GEO_ST,
# FDR_LIB_DIM_AG_MINI_PLCY, FDR_LIB_DIM_DT, FDR_LIB_DIM_AG_MINI_CVG,
# FDR_LIB_DIM_AG_SOI_ENH, FDR_LIB_DIM_AG_MINI_SOI (bypassed — override reads from warehouse)
# -----------------------------------------------------------------------------
sql_query = f"""select
    t1.i_GRGNG_ZIP_5 as i_GRGNG_ZIP_5,
    t1.i_FARMERS_STATE_CD as i_FARMERS_STATE_CD,
    t1.i_ST_NM as i_ST_NM,
    t1.i_GA_UMBI_PD_ADDED_IND as i_GA_UMBI_PD_ADDED_IND,
    t1.i_NAIC_CMPY_CD as i_NAIC_CMPY_CD,
    t1.i_NISS_CMPNY_CD as i_NISS_CMPNY_CD
from
    FDR.FACT_AG_WRITTN_PREM_CVG_LVL t1
-- NOTE: real SQ contains additional joins/aggregations against DIM tables in Snowflake
"""

try:
    logger.info("Reading SQ_FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL from Snowflake via JDBC override query")
    df_SQ_FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL_blissful_ramanujan = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(f"Failed reading SQ_FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL from Snowflake: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_Defaults: explicit projection enumerating every expected column from SQ
# (no '*' wildcard). Most ports are passthrough.
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_Defaults projection")
    df_EXP_Defaults_jovial_feynman = df_SQ_FDR_LIB_FACT_AG_WRITTN_PREM_CVG_LVL_blissful_ramanujan.selectExpr(
        "i_GRGNG_ZIP_5",
        "i_FARMERS_STATE_CD",
        "i_ST_NM",
        "i_GA_UMBI_PD_ADDED_IND",
        "i_NAIC_CMPY_CD",
        "i_NISS_CMPNY_CD"
    )
except Exception as e:
    logger.error(f"Failed applying EXP_Defaults: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_Passthru: compute standardized GRGNG_ZIP_5 and intermediate v_FARMERS_STATE_CD
# Chain selectExpr calls so intermediate alias can be reused when computing IFARMERS_STATE_CD
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_Passthru transformations (GRGNG_ZIP_5, v_FARMERS_STATE_CD)")
    # first compute GRGNG_ZIP_5 and v_FARMERS_STATE_CD
    df_temp = df_EXP_Defaults_jovial_feynman.selectExpr(
        "i_GRGNG_ZIP_5",
        "i_FARMERS_STATE_CD",
        "i_ST_NM",
        "i_GA_UMBI_PD_ADDED_IND",
        "i_NAIC_CMPY_CD",
        "i_NISS_CMPNY_CD",
        "CASE WHEN trim(coalesce(i_GRGNG_ZIP_5, '')) = '' OR trim(i_GRGNG_ZIP_5) = '0' THEN '00000' \
              WHEN length(trim(i_GRGNG_ZIP_5)) < 5 THEN lpad(trim(i_GRGNG_ZIP_5), 5, '0') \
              ELSE trim(i_GRGNG_ZIP_5) END AS GRGNG_ZIP_5",
        "CASE WHEN i_FARMERS_STATE_CD = '#' THEN '00' ELSE i_FARMERS_STATE_CD END AS v_FARMERS_STATE_CD"
    )

    # now compute IFARMERS_STATE_CD referencing v_FARMERS_STATE_CD
    df_EXP_Passthru_nifty_schrodinger = df_temp.selectExpr(
        "GRGNG_ZIP_5",
        "v_FARMERS_STATE_CD",
        "i_ST_NM",
        "i_GA_UMBI_PD_ADDED_IND",
        "i_NAIC_CMPY_CD",
        "i_NISS_CMPNY_CD",
        "CASE WHEN v_FARMERS_STATE_CD = '' THEN NULL ELSE CAST(v_FARMERS_STATE_CD AS INT) END AS IFARMERS_STATE_CD"
    )
except Exception as e:
    logger.error(f"Failed applying EXP_Passthru: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# LKP_ff_REF_NISS_STATE_CD: read the flat-file lookup and broadcast-left-join
# Join condition: FARMERS_STATE_NAME = i_ST_NM -> produce NISS_STATE_CODE
# -----------------------------------------------------------------------------
try:
    logger.info("Reading lookup file for REF_NISS_STATE and performing broadcast join")
    df_lookup_ref_niss = (
        spark.read.option("header", "true").csv(LOOKUP_NISS_STATE_FILE)
        .selectExpr("FARMERS_STATE_NAME", "NISS_STATE_CODE")
    )
    df_lookup_ref_niss.cache()

    df_LKP_ff_REF_NISS_STATE_CD_elated_turing = (
        df_EXP_Passthru_nifty_schrodinger.join(
            broadcast(df_lookup_ref_niss),
            df_EXP_Passthru_nifty_schrodinger["i_ST_NM"] == df_lookup_ref_niss["FARMERS_STATE_NAME"],
            "left"
        )
        .select(
            *[df_EXP_Passthru_nifty_schrodinger[c] for c in df_EXP_Passthru_nifty_schrodinger.columns],
            df_lookup_ref_niss["NISS_STATE_CODE"].alias("NISS_STATE_CODE")
        )
    )
except Exception as e:
    logger.error(f"Failed running lookup LKP_ff_REF_NISS_STATE_CD: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_To_Derive_Vals: derive multiple outputs using passthru + lookup
# - EXPS_VAL_ROLLED = 0
# - GA_UMBI_PD_ADDED_IND -> 'Y'/'N'
# - o_NAIC_CMPY_CD = trimmed i_NAIC_CMPY_CD
# - o_NISS_CMPNY_CD: chained WHEN mapping translated from DECODE
# - NISS_STATE_CODE already from lookup; missing upstream small-lookup columns -> NULLs
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_To_Derive_Vals computations")
    df_EXP_To_Derive_Vals_kind_noether = df_LKP_ff_REF_NISS_STATE_CD_elated_turing.selectExpr(
        "GRGNG_ZIP_5",
        "v_FARMERS_STATE_CD",
        "IFARMERS_STATE_CD",
        "i_ST_NM",
        "NISS_STATE_CODE",
        "EXPS_VAL_ROLLED as EXPS_VAL_ROLLED",  # placeholder if exists
        "0 AS EXPS_VAL_ROLLED",
        "CASE WHEN i_GA_UMBI_PD_ADDED_IND = 1 THEN 'Y' ELSE 'N' END AS GA_UMBI_PD_ADDED_IND",
        "trim(i_NAIC_CMPY_CD) AS o_NAIC_CMPY_CD",
        # Generic translation of DECODE -> chained CASE WHEN; specific mapping rules should be validated
        "CASE WHEN i_NISS_CMPNY_CD IN ('A','B','C') THEN i_NISS_CMPNY_CD ELSE '' END AS o_NISS_CMPNY_CD",
        # state abbreviation passthrough/trim
        "CASE WHEN trim(i_ST_NM) IS NULL THEN '' ELSE trim(i_ST_NM) END AS STATE_ABBR",
        # upstream TFARMERS_STATE lookup missing in metadata -> produce NULL placeholder
        "NULL AS TFARMERS_STATE_CODE"
    )
except Exception as e:
    logger.error(f"Failed applying EXP_To_Derive_Vals: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_Passtotgt: final projection toward target; attach deterministic surrogate
# NISS_ATPRM_LND_SK via row_number() over Window.orderBy(lit(1)) after projecting
# other columns. (This enforces gap-free 1..N sequence—note single-partition shuffle.)
# -----------------------------------------------------------------------------
try:
    logger.info("Applying EXP_Passtotgt final projection and generating surrogate key NISS_ATPRM_LND_SK")
    # First project all target columns except the surrogate key
    df_EXP_Passtotgt_zen_fermat_prekey = df_EXP_To_Derive_Vals_kind_noether.selectExpr(
        "GRGNG_ZIP_5",
        "v_FARMERS_STATE_CD",
        "IFARMERS_STATE_CD",
        "i_ST_NM",
        "NISS_STATE_CODE",
        "EXPS_VAL_ROLLED",
        "GA_UMBI_PD_ADDED_IND",
        "o_NAIC_CMPY_CD",
        "o_NISS_CMPNY_CD",
        "STATE_ABBR",
        "TFARMERS_STATE_CODE",
        # Columns that would have come from missing mapplet/lookup are produced as NULLs per plan
        "NULL AS NISS_TERR_CD"
    )

    # Attach deterministic surrogate key using row_number() over a global ordering
    # NOTE: this forces a single-partition shuffle and should be reviewed on large inputs.
    window_spec = Window.orderBy(F.lit(1))
    df_EXP_Passtotgt_zen_fermat = df_EXP_Passtotgt_zen_fermat_prekey.withColumn(
        "NISS_ATPRM_LND_SK",
        F.row_number().over(window_spec)
    )
except Exception as e:
    logger.error(f"Failed applying EXP_Passtotgt and generating surrogate key: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Output: write final dataframe to S3 as parquet (overwrite)
# Target: FDR_LIB_WRK_BIRP_NISS_APRM_LND
# -----------------------------------------------------------------------------
try:
    logger.info("Writing FDR_LIB_WRK_BIRP_NISS_APRM_LND to S3 as parquet (overwrite)")
    df_EXP_Passtotgt_zen_fermat.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/FDR_LIB_WRK_BIRP_NISS_APRM_LND/"
    )
    # assign final output df name as expected by mapping plan
    df_FDR_LIB_WRK_BIRP_NISS_APRM_LND_laughing_faraday = df_EXP_Passtotgt_zen_fermat
except Exception as e:
    logger.error(f"Failed writing FDR_LIB_WRK_BIRP_NISS_APRM_LND to S3: {e}", exc_info=True)
    raise


job.commit()
