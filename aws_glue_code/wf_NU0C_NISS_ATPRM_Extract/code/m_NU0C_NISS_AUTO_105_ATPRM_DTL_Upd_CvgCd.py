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

# ------------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL
# Try staged parquet read from S3 first, fallback to catalog/source on failure
try:
    logger.info("Attempting to read staged WRK_BIRP_NISS_APRM_DETL from s3 first")
    try:
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_friendly_babbage = spark.read.parquet(
            f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
        )
        logger.info("Read WRK_BIRP_NISS_APRM_DETL from S3 staged path")
    except Exception as e_s3:
        logger.warning("Staged S3 path for WRK_BIRP_NISS_APRM_DETL not available, falling back to catalog/source read: %s", e_s3)
        # Fallback: read from Glue Catalog (or other declared source). Replace database/table placeholders as needed.
        try:
            logger.info("Reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL from Glue Data Catalog")
            dyf = glueContext.create_dynamic_frame.from_catalog(database = "REPLACE_WITH_GLUE_DATABASE", table_name = "WRK_BIRP_NISS_APRM_DETL")
            df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_friendly_babbage = dyf.toDF()
            logger.info("Successfully read WRK_BIRP_NISS_APRM_DETL from Glue Catalog")
        except Exception as e_cat:
            logger.error(f"Failed fallback catalog read for WRK_BIRP_NISS_APRM_DETL: {e_cat}", exc_info=True)
            raise
except Exception as e:
    logger.error(f"Failed to obtain source WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# ------------------------------------------------------------------------------
# Application Source Qualifier: SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL
# This ASQ has a SQL override referencing the staged table. Register the staged DF as a temp view
try:
    logger.info("Registering staged dataframe as temp view WRK_BIRP_NISS_APRM_DETL and executing SQL override")
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_friendly_babbage.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")

    sql_query = f"""select
    *
from
    WRK_BIRP_NISS_APRM_DETL
where
    ST_ABBR NOT IN ('NY','NJ')
"""

    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_admiring_feynman = spark.sql(sql_query)
    logger.info("Executed SQL override for SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL")
except Exception as e:
    logger.error(f"Failed processing Application Source Qualifier SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# ------------------------------------------------------------------------------
# Expression: EXP_Pass_Through
# Explicit passthrough projection (list all columns explicitly at runtime)
try:
    logger.info("Running EXP_Pass_Through projection")
    cols_pass = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_admiring_feynman.columns
    # enumerate every column explicitly rather than using '*'
    df_EXP_Pass_Through_lucid_einstein = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_admiring_feynman.select(*cols_pass)
    logger.info("Completed EXP_Pass_Through")
except Exception as e:
    logger.error(f"Failed EXP_Pass_Through: {e}", exc_info=True)
    raise

# ------------------------------------------------------------------------------
# Expression: EXP_BILimit_Split
try:
    logger.info("Running EXP_BILimit_Split to parse BI_LMT into parts and decimals")
    # First compute a cleaned BI_LMT with commas removed and trimmed
    df_temp = df_EXP_Pass_Through_lucid_einstein.select(*df_EXP_Pass_Through_lucid_einstein.columns,
                                                        "replace(trim(BI_LMT), ',', '') as BI_LMT_CLEAN")
    # Now compute number of parts and extract part1/part2/part3 then cast numeric parts
    df_EXP_BILimit_Split_busy_planck = df_temp.selectExpr(
        *df_temp.columns,
        "size(split(BI_LMT_CLEAN, '/')) as BI_LMT_NO_OF_PARTS",
        "cast(element_at(split(BI_LMT_CLEAN, '/'), 1) as decimal(18,2)) as BI_LMT_1_Decimal",
        "cast(element_at(split(BI_LMT_CLEAN, '/'), 2) as decimal(18,2)) as BI_LMT_2_Decimal",
        "cast(element_at(split(BI_LMT_CLEAN, '/'), 3) as decimal(18,2)) as BI_LMT_3_Decimal",
        "BI_LMT_CLEAN as SRC_BI_LMT"
    )
    logger.info("Completed EXP_BILimit_Split")
except Exception as e:
    logger.error(f"Failed EXP_BILimit_Split: {e}", exc_info=True)
    raise

# ------------------------------------------------------------------------------
# Expression: EXP_CvgAmount_Split
try:
    logger.info("Running EXP_CvgAmount_Split to parse CVG_AMT into parts and decimals")
    # Clean CVG_AMT, remove commas and trim
    df_temp2 = df_EXP_Pass_Through_lucid_einstein.select(*df_EXP_Pass_Through_lucid_einstein.columns,
                                                          "replace(trim(CVG_AMT), ',', '') as CVG_AMT_CLEAN")
    df_EXP_CvgAmount_Split_wonderful_descartes = df_temp2.selectExpr(
        *df_temp2.columns,
        "size(split(CVG_AMT_CLEAN, '/')) as CVG_AMT_NO_OF_PARTS",
        "cast(element_at(split(CVG_AMT_CLEAN, '/'), 1) as decimal(18,2)) as CVG_AMT_1_Decimal",
        "cast(element_at(split(CVG_AMT_CLEAN, '/'), 2) as decimal(18,2)) as CVG_AMT_2_Decimal",
        "CVG_AMT_CLEAN as SRC_CVG_AMT"
    )
    logger.info("Completed EXP_CvgAmount_Split")
except Exception as e:
    logger.error(f"Failed EXP_CvgAmount_Split: {e}", exc_info=True)
    raise

# ------------------------------------------------------------------------------
# Expression: EXP_Derive_NISS_CVG_CD_And_PassThru
# Join the three inputs on NISS_APRM_DETL_SK and derive/clean NISS coverage code
try:
    logger.info("Joining inputs for EXP_Derive_NISS_CVG_CD_And_PassThru")
    # base join: pass-through + CVG amount split + BI limit split
    df_joined = (
        df_EXP_Pass_Through_lucid_einstein
        .join(df_EXP_CvgAmount_Split_wonderful_descartes, on="NISS_APRM_DETL_SK", how="inner")
        .join(df_EXP_BILimit_Split_busy_planck, on="NISS_APRM_DETL_SK", how="inner")
    )

    logger.info("Computing derived NISS coverage code and pass-through columns")
    # compute a cleaned/aliased coverage code column. Use CASE to produce '???' when missing/empty.
    df_EXP_Derive_NISS_CVG_CD_And_PassThru_reverent_noether = df_joined.selectExpr(
        *df_joined.columns,
        "case when trim(coalesce(NISS_CVG_CD, '')) = '' then '???' else trim(NISS_CVG_CD) end as o_NISS_CVG_CD"
    )
    logger.info("Completed EXP_Derive_NISS_CVG_CD_And_PassThru")
except Exception as e:
    logger.error(f"Failed EXP_Derive_NISS_CVG_CD_And_PassThru: {e}", exc_info=True)
    raise

# ------------------------------------------------------------------------------
# Update Strategy: UPD_NISS_CVG_CD
# Derive dd_op and apply load-modify-store-back to WRK_BIRP_NISS_APRM_DETL parquet target
try:
    logger.info("Deriving dd_op for UPD_NISS_CVG_CD and filtering rejects")
    # add dd_op literal column; here mapping marks rows as UPDATE
    df_with_dd = df_EXP_Derive_NISS_CVG_CD_And_PassThru_reverent_noether.selectExpr(
        *df_EXP_Derive_NISS_CVG_CD_And_PassThru_reverent_noether.columns,
        "'UPDATE' as dd_op"
    )

    df_filtered = df_with_dd.filter("dd_op <> 'REJECT'")

    # changed keys are rows that are INSERT/UPDATE/DELETE (here we expect UPDATE but include all per rule)
    changed_keys_df = df_filtered.filter("dd_op in ('INSERT','UPDATE','DELETE')").select("NISS_APRM_DETL_SK").dropDuplicates()

    # Load current full target table from S3 parquet
    try:
        logger.info("Reading current target WRK_BIRP_NISS_APRM_DETL from S3 for load-modify-store-back")
        existing_df = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
    except Exception as e_read:
        logger.info("Target parquet for WRK_BIRP_NISS_APRM_DETL not found or unreadable: %s", e_read)
        # If target doesn't exist yet, treat existing_df as empty schema by using changed rows only
        existing_df = spark.createDataFrame([], schema=df_filtered.schema)

    # Anti-join to remove rows that will be replaced or deleted
    try:
        logger.info("Applying anti-join to drop rows being changed/removed from existing target")
        existing_anti = existing_df.join(changed_keys_df, on="NISS_APRM_DETL_SK", how="left_anti")
    except Exception as e_anti:
        logger.error(f"Failed during anti-join in Update Strategy: {e_anti}", exc_info=True)
        raise

    # Prepare rows to be inserted/updated (exclude DELETE rows)
    updated_rows = df_filtered.filter("dd_op in ('INSERT','UPDATE')").drop("dd_op")

    # Build the final combined dataframe: existing rows not changed + updated/insert rows
    try:
        logger.info("Unioning existing_anti with updated/insert rows to form new full target")
        # use unionByName allowMissingColumns to tolerate schema differences
        df_UPD_NISS_CVG_CD_dazzling_boltzmann = existing_anti.unionByName(updated_rows, allowMissingColumns=True)
    except Exception as e_union:
        logger.error(f"Failed to union existing and updated rows in Update Strategy: {e_union}", exc_info=True)
        raise

    # Write the combined dataframe back to the same S3 parquet path (overwrite)
    try:
        logger.info("Writing updated full target WRK_BIRP_NISS_APRM_DETL back to S3 (overwrite)")
        df_UPD_NISS_CVG_CD_dazzling_boltzmann.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
    except Exception as e_write:
        logger.error(f"Failed writing updated WRK_BIRP_NISS_APRM_DETL to S3: {e_write}", exc_info=True)
        raise

except Exception as e:
    logger.error(f"Failed UPD_NISS_CVG_CD load-modify-store-back process: {e}", exc_info=True)
    raise

# ------------------------------------------------------------------------------
# Output: WRK_BIRP_NISS_APRM_DETL
# Finalize output dataframe variable and write as parquet to S3
try:
    logger.info("Assigning output dataframe variable for WRK_BIRP_NISS_APRM_DETL and writing to S3 as parquet (overwrite)")
    df_WRK_BIRP_NISS_APRM_DETL_charming_curie = df_UPD_NISS_CVG_CD_dazzling_boltzmann
    df_WRK_BIRP_NISS_APRM_DETL_charming_curie.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/")
    logger.info("Completed write of WRK_BIRP_NISS_APRM_DETL to S3")
except Exception as e:
    logger.error(f"Failed final write for WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise


job.commit()
