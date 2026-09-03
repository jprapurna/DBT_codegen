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
GLUE_DATABASE = "REPLACE_WITH_GLUE_DATABASE"

from pyspark.sql.functions import regexp_replace, split, size, element_at, col, trim, rtrim, ltrim, when, lit, row_number
from pyspark.sql.window import Window

# -------------------------------------------------------------------------
# FDR_LIB_WRK_BIRP_NISS_APRM_DETL (Source)
# Attempt an S3-first read of the staged parquet for WRK_BIRP_NISS_APRM_DETL,
# falling back to the Glue catalog read if the parquet isn't present.
# Project exactly the listed columns.
# -------------------------------------------------------------------------
try:
    logger.info("Attempting to read staged WRK_BIRP_NISS_APRM_DETL from S3 first")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_feynman = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
        .select(
            "NISS_APRM_DETL_SK",
            "ST_ABBR",
            "ACCTNG_LOB",
            "CVG_TYP_CD",
            "CVG_AMT",
            "NISS_CVG_CD",
            "NISS_ST_CD",
        )
    )
    logger.info("Successfully read WRK_BIRP_NISS_APRM_DETL from S3 staged parquet")
except Exception as e:
    logger.warning("Staged parquet for WRK_BIRP_NISS_APRM_DETL not found in S3; falling back to Glue Catalog read")
    try:
        # Glue catalog fallback read
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_feynman = (
            dyf.toDF()
            .select(
                "NISS_APRM_DETL_SK",
                "ST_ABBR",
                "ACCTNG_LOB",
                "CVG_TYP_CD",
                "CVG_AMT",
                "NISS_CVG_CD",
                "NISS_ST_CD",
            )
        )
        logger.info("Successfully read WRK_BIRP_NISS_APRM_DETL from Glue Catalog")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# -------------------------------------------------------------------------
# SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL (Application Source Qualifier)
# SQL override selecting from staged WRK_BIRP_NISS_APRM_DETL where ST_ABBR='VA'.
# Because the upstream WRK_ table is staged in this job, register the staged
# dataframe as a temp view and run the override via spark.sql.
# -------------------------------------------------------------------------
try:
    # register staged dataframe as temp view expected by the override
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_feynman.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
    sql_query = f"""select
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    NISS_CVG_CD,
    NISS_ST_CD,
    -- duplicate NISS_ST_CD into NISS_ST_CD1 because downstream expects both
    NISS_ST_CD as NISS_ST_CD1
from
    WRK_BIRP_NISS_APRM_DETL
where
    ST_ABBR = 'VA'"""

    logger.info("Running SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL via spark.sql against staged temp view")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_gentle_kant = spark.sql(sql_query)
    logger.info("Completed SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL")
except Exception as e:
    logger.error(f"Failed processing SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# -------------------------------------------------------------------------
# EXP_PassThru (Expression) - simple explicit passthrough projection
# Project each named output column explicitly (no '*' wildcard)
# -------------------------------------------------------------------------
try:
    logger.info("Applying EXP_PassThru projection")
    df_EXP_PassThru_hopeful_maxwell = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_gentle_kant.selectExpr(
        "NISS_APRM_DETL_SK",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "CVG_AMT",
        "NISS_CVG_CD",
        "NISS_ST_CD",
        "NISS_ST_CD1",
    )
    logger.info("Completed EXP_PassThru projection")
except Exception as e:
    logger.error(f"Failed EXP_PassThru projection: {e}", exc_info=True)
    raise

# -------------------------------------------------------------------------
# EXP_CvgAmount_Split (Expression)
# Clean CVG_AMT, split on a delimiter (assume '/' separator), compute parts,
# produce string and decimal versions of parts and SRC_CVG_AMT.
# -------------------------------------------------------------------------
try:
    logger.info("Applying EXP_CvgAmount_Split transformations")
    df_tmp = df_EXP_PassThru_hopeful_maxwell.withColumn("CVG_AMT_CLEAN", regexp_replace(col("CVG_AMT"), ",", ""))

    # split into parts by '/' (common delimiter for 'amount1/amount2')
    df_tmp = df_tmp.withColumn("CVG_AMT_PARTS", split(col("CVG_AMT_CLEAN"), "/"))
    df_tmp = df_tmp.withColumn("CVG_AMT_NO_OF_PARTS", size(col("CVG_AMT_PARTS")))

    # extract string parts (element_at uses 1-based indexing)
    df_tmp = df_tmp.withColumn("CVG_AMT_1_String", element_at(col("CVG_AMT_PARTS"), 1))
    df_tmp = df_tmp.withColumn("CVG_AMT_2_String", when(col("CVG_AMT_NO_OF_PARTS") >= 2, element_at(col("CVG_AMT_PARTS"), 2)).otherwise(lit(None)))

    # safe numeric cast: remove any non-numeric like spaces and cast to double
    df_tmp = df_tmp.withColumn("CVG_AMT_1_Decimal", when(col("CVG_AMT_1_String").isNotNull(), regexp_replace(col("CVG_AMT_1_String"), "[^0-9\.\-]", "").cast("double")).otherwise(lit(None)))
    df_tmp = df_tmp.withColumn("CVG_AMT_2_Decimal", when(col("CVG_AMT_2_String").isNotNull(), regexp_replace(col("CVG_AMT_2_String"), "[^0-9\.\-]", "").cast("double")).otherwise(lit(None)))

    # keep original cleaned amount as SRC_CVG_AMT
    df_EXP_CvgAmount_Split_relaxed_hawking = df_tmp.withColumn("SRC_CVG_AMT", col("CVG_AMT_CLEAN")).drop("CVG_AMT_CLEAN", "CVG_AMT_PARTS")
    logger.info("Completed EXP_CvgAmount_Split transformations")
except Exception as e:
    logger.error(f"Failed EXP_CvgAmount_Split transformations: {e}", exc_info=True)
    raise

# -------------------------------------------------------------------------
# EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru (Expression)
# Left-join the pass-thru and split-amount frames to the SQ frame on
# NISS_APRM_DETL_SK and compute derived column o_NISS_PLCY_LIMIT_CD_VA.
# -------------------------------------------------------------------------
try:
    logger.info("Joining SQ, EXP_PassThru and EXP_CvgAmount_Split for EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru")
    df_joined = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_gentle_kant.alias("sq") \
        .join(df_EXP_PassThru_hopeful_maxwell.alias("pt"), on=["NISS_APRM_DETL_SK"], how="left") \
        .join(df_EXP_CvgAmount_Split_relaxed_hawking.alias("split"), on=["NISS_APRM_DETL_SK"], how="left")

    logger.info("Computing derived columns for EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru")
    # Example translated logic: determine a policy limit code for VA using available fields.
    # NOTE: The original Informatica IIF/DECODE logic should be reviewed; this implements
    # a logical mapping based on presence/values of split decimals and CVG_TYP_CD.
    df_trans = df_joined.withColumn(
        "o_NISS_PLCY_LIMIT_CD_VA",
        when((col("CVG_AMT_NO_OF_PARTS") > 1) & (col("CVG_AMT_1_Decimal").isNotNull()) & (col("CVG_AMT_2_Decimal").isNotNull()), lit("MULTI"))
        .when((col("CVG_AMT_1_Decimal").isNotNull()) & (col("CVG_AMT_1_Decimal") > 0), lit("LIMIT"))
        .when(col("CVG_TYP_CD").isNotNull() & (trim(col("CVG_TYP_CD")) != ""), col("CVG_TYP_CD"))
        .otherwise(lit(None))
    )

    # Preserve/explicitly select the required output columns: pass-through fields plus the derived
    df_EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru_relaxed_pascal = df_trans.select(
        "NISS_APRM_DETL_SK",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "CVG_AMT",
        "NISS_CVG_CD",
        "NISS_ST_CD",
        "NISS_ST_CD1",
        "CVG_AMT_1_String",
        "CVG_AMT_2_String",
        "CVG_AMT_1_Decimal",
        "CVG_AMT_2_Decimal",
        "CVG_AMT_NO_OF_PARTS",
        "SRC_CVG_AMT",
        "o_NISS_PLCY_LIMIT_CD_VA",
    )
    logger.info("Completed EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru")
except Exception as e:
    logger.error(f"Failed EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru: {e}", exc_info=True)
    raise

# -------------------------------------------------------------------------
# UPDTRANS (Update Strategy)
# Derive dd_op (DD_UPDATE for all rows per node config), drop REJECTs (none
# expected), and apply load-modify-store-back against the target parquet.
# -------------------------------------------------------------------------
try:
    logger.info("Applying Update Strategy marker column dd_op")
    df_UPDTRANS_heroic_dirac = df_EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru_relaxed_pascal.withColumn("dd_op", lit("UPDATE"))

    # drop any REJECT rows if present
    df_UPDTRANS_heroic_dirac = df_UPDTRANS_heroic_dirac.filter(col("dd_op") != "REJECT")
    logger.info("Filtered out REJECT rows (if any) from UPDTRANS")
except Exception as e:
    logger.error(f"Failed deriving dd_op in UPDTRANS: {e}", exc_info=True)
    raise

# load-modify-store-back pattern
target_path = f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"
try:
    logger.info(f"Reading existing target table from {target_path} for load-modify-store-back")
    existing_df = spark.read.parquet(target_path)
    logger.info("Successfully read existing target for UPDTRANS apply")
except Exception as e:
    # If the target doesn't exist yet, treat existing_df as empty schema-matching dataframe
    logger.warning(f"Existing target at {target_path} could not be read (may not exist). Proceeding with empty existing set: {e}")
    # create empty DataFrame with same schema as incoming DF by selecting zero rows
    existing_df = df_UPDTRANS_heroic_dirac.limit(0)

try:
    logger.info("Performing anti-join to remove rows from existing target that are being changed")
    # keys of changed rows
    changed_keys_df = df_UPDTRANS_heroic_dirac.select("NISS_APRM_DETL_SK").distinct()

    existing_surviving = existing_df.join(changed_keys_df, on=["NISS_APRM_DETL_SK"], how="left_anti")
    logger.info("Anti-join completed; existing rows being updated/deleted removed")

    logger.info("Unioning surviving existing rows with incoming INSERT/UPDATE rows (DELETE rows omitted)")
    # keep only rows that are INSERT or UPDATE (here dd_op = 'UPDATE')
    incoming_to_apply = df_UPDTRANS_heroic_dirac.filter(col("dd_op").isin("INSERT", "UPDATE"))

    # Ensure schemas align for unionByName
    from functools import reduce
    combined_df = existing_surviving.unionByName(incoming_to_apply, allowMissingColumns=True)

    # write back the full combined dataframe to the same target path (full overwrite)
    logger.info("Writing combined target dataframe back to target path (overwrite). Note: full-table overwrite may be expensive for large targets")
    combined_df.write.mode("overwrite").parquet(target_path)
    logger.info("Completed writing updated target from UPDTRANS load-modify-store-back")
except Exception as e:
    logger.error(f"Failed applying UPDTRANS load-modify-store-back: {e}", exc_info=True)
    raise

# -------------------------------------------------------------------------
# Final Output node: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1
# Ensure the final dataframe variable is assigned as required by downstream
# naming and write the final result to S3 as parquet (overwrite).
# -------------------------------------------------------------------------
try:
    # assign the expected output dataframe variable name so downstream references resolve
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_blissful_noether = df_UPDTRANS_heroic_dirac

    # write intermediate/final target to S3 (overwrite)
    logger.info("Writing final target WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_blissful_noether.write.mode("overwrite").parquet(
        target_path
    )
    logger.info("Successfully wrote final target WRK_BIRP_NISS_APRM_DETL1 to S3")
except Exception as e:
    logger.error(f"Failed writing final target WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True)
    raise


job.commit()
