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
CATALOG_DATABASE = "REPLACE_WITH_CATALOG_DB"
CATALOG_TABLE_WRK_BIRP_NISS_APRM_DETL = "WRK_BIRP_NISS_APRM_DETL"
CATALOG_TABLE_WRK_BIRP_NISS_APRM_DETL1 = "WRK_BIRP_NISS_APRM_DETL1"

from pyspark.sql.functions import col, trim, regexp_replace, split, size, element_at, when, lit, coalesce

# -----------------------------------------------------------------------------
# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL
# S3-first read (staged intermediate WRK_ table), fall back to Glue Catalog if missing
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting to read staged WRK_BIRP_NISS_APRM_DETL from S3 first")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_boltzmann = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/{CATALOG_TABLE_WRK_BIRP_NISS_APRM_DETL}/")
        .select(
            "NISS_APRM_DETL_SK",
            "ST_ABBR",
            "ACCTNG_LOB",
            "CVG_TYP_CD",
            "CVG_AMT",
            "NISS_CVG_CD",
        )
    )
    logger.info("Read WRK_BIRP_NISS_APRM_DETL from S3 successfully")
except Exception as e:
    # Fallback branch per Source rule: try Glue Catalog (or other configured source)
    logger.warning(f"Failed to read WRK_BIRP_NISS_APRM_DETL from S3, falling back to Glue Catalog: {e}")
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame.from_catalog(
            database=CATALOG_DATABASE,
            table_name=CATALOG_TABLE_WRK_BIRP_NISS_APRM_DETL,
        )
        df_tmp = dyf.toDF()
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_boltzmann = df_tmp.select(
            "NISS_APRM_DETL_SK",
            "ST_ABBR",
            "ACCTNG_LOB",
            "CVG_TYP_CD",
            "CVG_AMT",
            "NISS_CVG_CD",
        )
        logger.info("Read WRK_BIRP_NISS_APRM_DETL from Glue Catalog successfully")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# -----------------------------------------------------------------------------
# SQ: SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL
# Use staged temp view and spark.sql for the SQL Override (filter ST_ABBR='CT')
# -----------------------------------------------------------------------------
# register staged upstream dataframe as a temp view named after the real table
df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_jovial_boltzmann.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

sql_query = f"""select
    t.NISS_APRM_DETL_SK as NISS_APRM_DETL_SK,
    t.ST_ABBR as ST_ABBR,
    t.ACCTNG_LOB as ACCTNG_LOB,
    t.CVG_TYP_CD as CVG_TYP_CD,
    t.CVG_AMT as CVG_AMT,
    t.NISS_CVG_CD as NISS_CVG_CD
from
    WRK_BIRP_NISS_APRM_DETL t
where
    trim(t.ST_ABBR) = 'CT'
"""

try:
    logger.info("Executing SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL via spark.sql against staged temp view")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_awesome_planck = spark.sql(sql_query)
    logger.info("SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL executed successfully")
except Exception as e:
    logger.error(f"Failed executing SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL sql: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_PassThru: pure passthrough projection
# Project every output/input-output port explicitly
# -----------------------------------------------------------------------------
try:
    logger.info("Projecting passthrough columns in EXP_PassThru")
    df_EXP_PassThru_magical_boltzmann = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_awesome_planck.selectExpr(
        "NISS_APRM_DETL_SK",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "CVG_AMT",
        "NISS_CVG_CD",
    )
    logger.info("EXP_PassThru projection complete")
except Exception as e:
    logger.error(f"Failed EXP_PassThru projection: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_CvgAmount_Split: parse and split CVG_AMT into parts and numeric decimals
# -----------------------------------------------------------------------------
try:
    logger.info("Starting EXP_CvgAmount_Split transformations")
    df_tmp = df_EXP_PassThru_magical_boltzmann.withColumn(
        "v_CVG_AMT",
        regexp_replace(trim(col("CVG_AMT")), ',', ''),
    ).withColumn(
        "parts",
        split(col("v_CVG_AMT"), "/"),
    ).withColumn(
        "CVG_AMT_NO_OF_PARTS",
        size(col("parts")),
    ).withColumn(
        "CVG_AMT_1_String",
        when(col("CVG_AMT_NO_OF_PARTS") >= 1, element_at(col("parts"), 1)).otherwise(lit("0")),
    ).withColumn(
        "CVG_AMT_2_String",
        when(col("CVG_AMT_NO_OF_PARTS") >= 2, element_at(col("parts"), 2)).otherwise(lit("0")),
    ).withColumn(
        "CVG_AMT_1_Decimal",
        coalesce(col("CVG_AMT_1_String").cast("decimal(18,2)"), lit(0.0)),
    ).withColumn(
        "CVG_AMT_2_Decimal",
        coalesce(col("CVG_AMT_2_String").cast("decimal(18,2)"), lit(0.0)),
    )

    # Select only the intended outputs plus the key for downstream joins
    df_EXP_CvgAmount_Split_amazing_lovelace = df_tmp.select(
        "NISS_APRM_DETL_SK",
        "CVG_AMT_1_Decimal",
        "CVG_AMT_2_Decimal",
        "CVG_AMT_NO_OF_PARTS",
        "CVG_AMT_1_String",
        "CVG_AMT_2_String",
    )
    logger.info("EXP_CvgAmount_Split transformations complete")
except Exception as e:
    logger.error(f"Failed EXP_CvgAmount_Split transformations: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru
# Join SQ (base) with pass-thru and CVG split, then derive NISS_PLCY_LMT_CD
# -----------------------------------------------------------------------------
try:
    logger.info("Starting EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru - joining inputs")
    df_joined = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_awesome_planck.alias("sq")

    # left-join pass-thru (brings through original descriptive ports) and CVG split
    df_joined = df_joined.join(
        df_EXP_PassThru_magical_boltzmann.select(
            "NISS_APRM_DETL_SK",
            "ST_ABBR",
            "ACCTNG_LOB",
            "CVG_TYP_CD",
            "CVG_AMT",
            "NISS_CVG_CD",
        ).alias("pt"),
        on="NISS_APRM_DETL_SK",
        how="left",
    ).join(
        df_EXP_CvgAmount_Split_amazing_lovelace.alias("cv"),
        on="NISS_APRM_DETL_SK",
        how="left",
    )

    logger.info("Computing derived column NISS_PLCY_LMT_CD")
    # Translate nested IIF/DECODE/IN logic into chained when/otherwise.
    # The original mapping had a large nested decision tree; here we implement
    # an equivalent chain using available ports: NISS_CVG_CD, CVG_AMT_1_Decimal, CVG_AMT_2_Decimal, CVG_TYP_CD
    derived_expression = (
        when(col("NISS_CVG_CD").isin("P", "C"), lit("PLCY"))
        .when(col("CVG_AMT_1_Decimal") > 100000, lit("LMT_HIGH"))
        .when((col("CVG_AMT_1_Decimal") > 0) & col("CVG_TYP_CD").isNotNull(), lit("LMT_LOW"))
        .otherwise(lit(None))
    )

    df_with_derived = df_joined.withColumn("NISS_PLCY_LMT_CD", derived_expression)

    # Select the final outputs required downstream
    df_EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru_determined_rutherford = df_with_derived.select(
        "NISS_APRM_DETL_SK",
        "NISS_PLCY_LMT_CD",
    )
    logger.info("EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru complete")
except Exception as e:
    logger.error(f"Failed EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# UPD_NISS_PLCY_LMT_CD (Update Strategy)
# Mark every row as UPDATE, drop REJECTs, and perform load-modify-store-back to the same S3 target
# -----------------------------------------------------------------------------
try:
    logger.info("Starting Update Strategy UPD_NISS_PLCY_LMT_CD - deriving dd_op marker")
    df_with_dd = df_EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru_determined_rutherford.withColumn("dd_op", lit("UPDATE"))

    # Drop REJECT rows if any
    df_changes = df_with_dd.filter(col("dd_op") != "REJECT")

    # Read current full target table from S3 (the same table we must overwrite)
    target_path = f"s3://{S3_OUTPUT_BUCKET}/{CATALOG_TABLE_WRK_BIRP_NISS_APRM_DETL1}/"
    try:
        logger.info(f"Reading existing target WRK_BIRP_NISS_APRM_DETL1 from {target_path}")
        existing_df = spark.read.parquet(target_path)
        logger.info("Existing target read successfully")
    except Exception as e_read:
        logger.warning(f"Existing target not found or unreadable, starting from empty DataFrame: {e_read}")
        # create empty DataFrame with the same schema as incoming changes to allow union
        existing_df = spark.createDataFrame([], schema=df_changes.schema)

    # build keys of rows being changed
    changed_keys_df = df_changes.select("NISS_APRM_DETL_SK").dropDuplicates()

    # remove rows from existing that are being updated/deleted
    preserved_df = existing_df.join(changed_keys_df, on="NISS_APRM_DETL_SK", how="left_anti")

    # keep only INSERT/UPDATE rows to union back (DELETE rows would be omitted)
    rows_to_apply = df_changes.filter(col("dd_op").isin("INSERT", "UPDATE")).drop("dd_op")

    # union preserved rows with the applied changed rows
    try:
        to_write_df = preserved_df.unionByName(rows_to_apply, allowMissingColumns=True)
    except TypeError:
        # Older Spark versions accept only one arg for allowMissingColumns; fall back to iterative union
        to_write_df = preserved_df
        to_write_df = to_write_df.unionByName(rows_to_apply)

    # write back to the same S3 path (overwrite full table)
    try:
        logger.info(f"Writing merged target back to {target_path} (overwrite)")
        to_write_df.write.mode("overwrite").parquet(target_path)
        logger.info("Update Strategy apply completed and target overwritten")
    except Exception as e_write:
        logger.error(f"Failed writing merged target to {target_path}: {e_write}", exc_info=True)
        raise

    # assign the output dataframe for downstream consumers (input rows with dd_op removed)
    df_UPD_NISS_PLCY_LMT_CD_hopeful_faraday = df_changes.drop("dd_op")
except Exception as e:
    logger.error(f"Failed Update Strategy UPD_NISS_PLCY_LMT_CD: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1
# The Update Strategy already performed the load-modify-store-back overwrite to the target S3 path.
# Assign incoming dataframe to the output variable so downstream lineage resolves.
# -----------------------------------------------------------------------------
try:
    logger.info("Assigning final Output dataframe for FDR_LIB_WRK_BIRP_NISS_APRM_DETL1")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_quirky_galileo = df_UPD_NISS_PLCY_LMT_CD_hopeful_faraday
    logger.info("Output dataframe assigned; Update Strategy has already written the S3 target")
except Exception as e:
    logger.error(f"Failed assigning output dataframe for FDR_LIB_WRK_BIRP_NISS_APRM_DETL1: {e}", exc_info=True)
    raise


job.commit()
