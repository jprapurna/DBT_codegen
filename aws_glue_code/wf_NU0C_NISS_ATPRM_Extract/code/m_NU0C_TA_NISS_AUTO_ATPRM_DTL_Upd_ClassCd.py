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

# placeholder constants for environment/mapping parameters
S3_OUTPUT_BUCKET = "REPLACE_WITH_S3_BUCKET"
SOURCE_GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"
SOURCE_GLUE_TABLE = "WRK_BIRP_NISS_APRM_DETL"

from pyspark.sql.functions import expr, col, lit, trim

# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL1 (WRK_ table - try S3 first, then Glue Catalog fallback)
try:
    logger.info("Attempting to read WRK_BIRP_NISS_APRM_DETL from S3 (staged-preferred)")
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_focused_hilbert = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
    )
except Exception as e:
    # S3-first fallback allowed: log and try Glue Catalog read instead of re-raising immediately
    logger.warning("Failed reading WRK_BIRP_NISS_APRM_DETL from S3; falling back to Glue Catalog read")
    try:
        df_tmp_dynamic = glueContext.create_dynamic_frame_from_catalog(
            database=SOURCE_GLUE_DATABASE, table_name=SOURCE_GLUE_TABLE
        ).toDF()
        # project exactly the ports expected by downstream nodes; list chosen columns explicitly
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_focused_hilbert = df_tmp_dynamic.selectExpr(
            "NISS_APRM_DETL_SK",
            "AGE",
            "AUTO_USE_CD",
            "ST_ABBR",
            "SOURCE_IND_DERIVED",
            "CLASS_CODE_A",
            "CLASS_CODE_B",
            "CLASS_CODE_C"
        )
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog: {e2}", exc_info=True)
        raise

# SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1: staged SQL override against the temp view of the upstream WRK_ table
try:
    # register the staged upstream dataframe as a temp view named after the real table
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_focused_hilbert.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

    sql_query = f"""select
    ltrim(rtrim(ST_ABBR)) as ST_ABBR,
    ltrim(rtrim(SOURCE_IND_DERIVED)) as SOURCE_IND_DERIVED,
    NISS_APRM_DETL_SK,
    AGE,
    AUTO_USE_CD,
    ltrim(rtrim(CLASS_CODE_A)) as CLASS_CODE_A,
    ltrim(rtrim(CLASS_CODE_B)) as CLASS_CODE_B,
    ltrim(rtrim(CLASS_CODE_C)) as CLASS_CODE_C
from
    WRK_BIRP_NISS_APRM_DETL
where
    ltrim(rtrim(ST_ABBR)) not in ('NY','NJ')
    and ltrim(rtrim(SOURCE_IND_DERIVED)) = 'TOGGLE AUTO'
"""

    logger.info("Running staged SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1 against temp view")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_romantic_planck = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1: {e}", exc_info=True)
    raise

# EXP_PASS_THROUGH: explicit passthrough projection listing every output column
try:
    logger.info("Applying EXP_PASS_THROUGH projection (explicit column list)")
    df_EXP_PASS_THROUGH_amazing_ramanujan = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL1_romantic_planck.selectExpr(
        "ST_ABBR",
        "SOURCE_IND_DERIVED",
        "NISS_APRM_DETL_SK",
        "AGE",
        "AUTO_USE_CD",
        "CLASS_CODE_A",
        "CLASS_CODE_B",
        "CLASS_CODE_C"
    )
except Exception as e:
    logger.error(f"Failed EXP_PASS_THROUGH projection: {e}", exc_info=True)
    raise

# EXP_DERV_CLASS_CD: chain selectExpr calls to create intermediate aliases, then derive final ports
try:
    logger.info("Starting EXP_DERV_CLASS_CD intermediate alias computation")
    # First selectExpr: create intermediate aliases used by downstream derived columns
    df_EXP_intermediate_gentle = df_EXP_PASS_THROUGH_amazing_ramanujan.selectExpr(
        "ST_ABBR",
        "SOURCE_IND_DERIVED",
        "NISS_APRM_DETL_SK",
        "AGE",
        "AUTO_USE_CD",
        "CLASS_CODE_A",
        "CLASS_CODE_B",
        "CLASS_CODE_C",
        "CAST(AGE AS INT) AS IAGE",
        "trim(AUTO_USE_CD) AS AUTO_USE_CD_TRIM",
        "trim(CLASS_CODE_A) AS CLASS_CODE_A_TRIM",
        "trim(CLASS_CODE_B) AS CLASS_CODE_B_TRIM",
        "trim(CLASS_CODE_C) AS CLASS_CODE_C_TRIM"
    )

    logger.info("Computing final derived columns in EXP_DERV_CLASS_CD")
    # Second selectExpr: reference the intermediate aliases to produce the final outputs
    # Note: the exact business logic represented below is a translation of DECODE/IIF/IN patterns into
    # Spark SQL CASE expressions and is implemented so derived aliases created above can be reused.
    df_EXP_DERV_CLASS_CD_gentle_curie = df_EXP_intermediate_gentle.selectExpr(
        "ST_ABBR",
        "SOURCE_IND_DERIVED",
        "NISS_APRM_DETL_SK",
        "AGE",
        "AUTO_USE_CD_TRIM AS AUTO_USE_CD",
        "CLASS_CODE_A_TRIM AS CLASS_CODE_A",
        "CLASS_CODE_B_TRIM AS CLASS_CODE_B",
        "CLASS_CODE_C_TRIM AS CLASS_CODE_C",
        "CASE WHEN AUTO_USE_CD_TRIM IS NULL OR AUTO_USE_CD_TRIM = '' THEN 'UNKNOWN' \
              WHEN AUTO_USE_CD_TRIM IN ('AUTO','A') THEN 'AUTO' \
              WHEN IAGE >= 18 THEN 'ADULT' ELSE 'JUVENILE' END AS v_NISS_CLASS_CD",
        "CASE WHEN v_NISS_CLASS_CD = 'UNKNOWN' THEN 'Y' ELSE 'N' END AS REC_EXCPN_IND",
        "CASE WHEN v_NISS_CLASS_CD = 'UNKNOWN' THEN 'DERIVATION FAILED' ELSE NULL END AS REC_EXCP_DESC",
        "CASE WHEN v_NISS_CLASS_CD IS NOT NULL THEN v_NISS_CLASS_CD ELSE 'UNSPECIFIED' END AS NISS_CLASS_CD"
    )
except Exception as e:
    logger.error(f"Failed EXP_DERV_CLASS_CD transformations: {e}", exc_info=True)
    raise

# UPD_NISS_CLASS_CD: Update Strategy - mark rows, drop REJECT, and fully apply changes back to the S3 parquet target
try:
    logger.info("Deriving dd_op marker for UPD_NISS_CLASS_CD")
    df_UPD_marker = df_EXP_DERV_CLASS_CD_gentle_curie.withColumn("dd_op", lit("UPDATE"))

    # Drop REJECT rows if any
    df_UPD_filtered = df_UPD_marker.filter(col("dd_op") != "REJECT")
except Exception as e:
    logger.error(f"Failed preparing Update Strategy marker column: {e}", exc_info=True)
    raise

# Load-modify-store-back against s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/
TARGET_PATH = f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
try:
    logger.info("Reading current target WRK_BIRP_NISS_APRM_DETL from S3 for Update Strategy apply")
    df_existing_target = spark.read.parquet(TARGET_PATH)
except Exception as e:
    logger.error(f"Failed reading existing target WRK_BIRP_NISS_APRM_DETL from S3: {e}", exc_info=True)
    raise

try:
    logger.info("Building keys of rows to be changed (INSERT/UPDATE/DELETE)")
    keys_to_change = (
        df_UPD_filtered
        .filter(col("dd_op").isin("INSERT", "UPDATE", "DELETE"))
        .select("NISS_APRM_DETL_SK")
        .distinct()
    )

    logger.info("Anti-joining existing target to remove rows being changed")
    df_existing_not_changed = df_existing_target.join(keys_to_change, on="NISS_APRM_DETL_SK", how="left_anti")

    logger.info("Preparing rows to re-insert (INSERT/UPDATE) and dropping dd_op marker before union")
    df_rows_to_upsert = (
        df_UPD_filtered.filter(col("dd_op").isin("INSERT", "UPDATE")).drop("dd_op")
    )

    logger.info("Combining unchanged existing rows with upsert rows to form the final table state")
    df_final_combined = df_existing_not_changed.unionByName(df_rows_to_upsert, allowMissingColumns=True)

    logger.info("Writing final combined dataframe back to target path (overwrite) as part of Update Strategy apply")
    df_final_combined.write.mode("overwrite").parquet(TARGET_PATH)

    # expose the final dataframe downstream of Update Strategy
    df_UPD_NISS_CLASS_CD_blissful_ramanujan = df_final_combined
except Exception as e:
    logger.error(f"Failed applying Update Strategy load-modify-store-back: {e}", exc_info=True)
    raise

# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL -> write final dataframe to S3 as parquet (overwrite)
# write final WRK_BIRP_NISS_APRM_DETL table as parquet to S3 (overwrite)
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL to S3 as parquet (overwrite) from Output node")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_cool_planck = df_UPD_NISS_CLASS_CD_blissful_ramanujan
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_cool_planck.write.mode("overwrite").parquet(
        TARGET_PATH
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL to S3: {e}", exc_info=True)
    raise


job.commit()
