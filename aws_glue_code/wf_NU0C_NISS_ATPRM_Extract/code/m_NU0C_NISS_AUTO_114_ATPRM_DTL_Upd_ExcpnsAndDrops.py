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
SOURCE_DATABASE = "REPLACE_WITH_SOURCE_DATABASE"
SOURCE_TABLE_WRK_APRM_DETL = "WRK_BIRP_NISS_APRM_DETL"
SOURCE_TABLE_WRK_APRM_DETL_2 = "WRK_BIRP_NISS_APRM_DETL_2"

from pyspark.sql.functions import col, lit, when, concat_ws, trim, substring, broadcast
from pyspark.sql.functions import row_number
from pyspark.sql.window import Window

# -----------------------------------------------------------------------------
# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 -> df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_sleepy_leibniz
# Attempt S3-first read of staged parquet, fallback to Glue Catalog read if missing
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting S3-first read for FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 from s3://{}/{}")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_sleepy_leibniz = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/{SOURCE_TABLE_WRK_APRM_DETL}/")
    )
    logger.info("Read FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 from staged S3 parquet")
except Exception as e:
    logger.warning("Staged parquet for FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 not found on S3, falling back to Glue Catalog read: %s", e)
    try:
        # Fallback to Glue Catalog read - project minimal/expected columns (NISS_APRM_DETL_SK at least)
        logger.info("Reading FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 from Glue Catalog (%s.%s)", SOURCE_DATABASE, SOURCE_TABLE_WRK_APRM_DETL)
        dyf = glueContext.create_dynamic_frame.from_catalog(database=SOURCE_DATABASE, table_name=SOURCE_TABLE_WRK_APRM_DETL)
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_sleepy_leibniz = dyf.toDF()
        # Ensure at least the expected key column exists; if not, add it as null to avoid downstream errors
        if 'NISS_APRM_DETL_SK' not in df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_sleepy_leibniz.columns:
            df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_sleepy_leibniz = df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_sleepy_leibniz.withColumn('NISS_APRM_DETL_SK', lit(None))
    except Exception as e2:
        logger.error(f"Failed reading FDR_LIB_WRK_BIRP_NISS_APRM_DETL2 from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# -----------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 -> df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2_romantic_maxwell
# Try staged parquet first for WRK_BIRP_NISS_APRM_DETL_2, fallback to catalog/JDBC
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting S3-first read for Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 from s3://%s/%s/", S3_OUTPUT_BUCKET, SOURCE_TABLE_WRK_APRM_DETL_2)
    df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2_romantic_maxwell = (
        spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/{SOURCE_TABLE_WRK_APRM_DETL_2}/")
    )
    logger.info("Read Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 from staged S3 parquet")
except Exception as e:
    logger.warning("Staged parquet for Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 not found on S3, falling back to Glue Catalog read: %s", e)
    try:
        logger.info("Reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 from Glue Catalog (%s.%s)", SOURCE_DATABASE, SOURCE_TABLE_WRK_APRM_DETL_2)
        dyf = glueContext.create_dynamic_frame.from_catalog(database=SOURCE_DATABASE, table_name=SOURCE_TABLE_WRK_APRM_DETL_2)
        df_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2_romantic_maxwell = dyf.toDF()
    except Exception as e2:
        logger.error(f"Failed reading Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# -----------------------------------------------------------------------------
# Application Source Qualifier: SQ_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops
# This ASQ has a SQL override selecting from FDR.WRK_BIRP_NISS_APRM_DETL; an upstream
# staged parquet is available, so register it as a temp view and run the override via spark.sql
# -----------------------------------------------------------------------------
try:
    # Register upstream staged dataframe as the view the override references
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL2_sleepy_leibniz.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
    sql_query = f"""select
    NISS_APRM_DETL_SK
from
    WRK_BIRP_NISS_APRM_DETL
"""
    logger.info("Running staged SQL override for SQ_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops via spark.sql")
    df_SQ_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops_sleepy_turing = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing staged SQL override for SQ_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Application Source Qualifier: SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2
# This ASQ contains a non-staged SQL override referencing FDR.WRK_BIRP_NISS_APRM_DETL -> read via JDBC
# -----------------------------------------------------------------------------
# Source: Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 (bypassed — JDBC override reads it directly)
sql_query = f"""select * from FDR.WRK_BIRP_NISS_APRM_DETL"""
try:
    logger.info("Reading SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 from Snowflake via JDBC override query")
    df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2_tender_hilbert = (
        spark.read.format("jdbc")
        .option("url", SNOWFLAKE_URL)
        .option("user", SNOWFLAKE_USER)
        .option("password", SNOWFLAKE_PASSWORD)
        .option("query", sql_query)
        .load()
    )
except Exception as e:
    logger.error(f"Failed reading SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2 from Snowflake: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Expression: EXP_PassThrough_Src1
# Projects NISS_APRM_DETL_SK and two literal-derived columns: REC_DROP_IND='Y', REC_DROP_RSN_DESC='997'
# -----------------------------------------------------------------------------
try:
    logger.info("Transform EXP_PassThrough_Src1: project NISS_APRM_DETL_SK and derived literals")
    df_EXP_PassThrough_Src1_gentle_maxwell = (
        df_SQ_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops_sleepy_turing.select(
            col('NISS_APRM_DETL_SK'),
            lit('Y').alias('REC_DROP_IND'),
            lit('997').alias('REC_DROP_RSN_DESC')
        )
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_PassThrough_Src1: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Expression: EXP_PassThrough_Src
# Pure passthrough from its ASQ - explicitly project all existing columns
# -----------------------------------------------------------------------------
try:
    logger.info("Transform EXP_PassThrough_Src: passthrough projection of ASQ columns")
    # enumerate incoming columns explicitly at runtime to avoid '*' while preserving all columns
    cols = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2_tender_hilbert.columns
    df_EXP_PassThrough_Src_dazzling_curie = df_SQ_Shortcut_to_WRK_BIRP_NISS_APRM_DETL_2_tender_hilbert.select(*[col(c) for c in cols])
except Exception as e:
    logger.error(f"Failed transforming EXP_PassThrough_Src: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Update Strategy: Upd_RecDrop_Ind
# Mark every incoming row as 'UPDATE', drop REJECTs (none expected), apply load-modify-store-back to
# target WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops, and assign transformed dataframe to df_Upd_RecDrop_Ind_optimistic_kant
# -----------------------------------------------------------------------------
try:
    logger.info("Applying Update Strategy Upd_RecDrop_Ind: derive dd_op and apply load-modify-store-back to WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops")
    df_marker = df_EXP_PassThrough_Src1_gentle_maxwell.withColumn('dd_op', lit('UPDATE'))
    # drop REJECT rows if any
    df_marker_surviving = df_marker.filter(col('dd_op') != 'REJECT')

    target_path = f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops/"
    try:
        logger.info("Reading existing target for ZeroPremDrops from %s", target_path)
        existing_df = spark.read.parquet(target_path)
    except Exception:
        logger.warning("Existing target for ZeroPremDrops not found on S3; starting from empty dataframe")
        # create empty dataframe with same schema as incoming (drop dd_op)
        existing_df = spark.createDataFrame([], df_marker_surviving.drop('dd_op').schema)

    # derive changed keys (UPDATE/DELETE) - here we marked everything UPDATE
    changed_keys_df = df_marker_surviving.select('NISS_APRM_DETL_SK').distinct()

    # anti-join to remove rows being changed from existing
    existing_after_anti = existing_df.join(changed_keys_df, on='NISS_APRM_DETL_SK', how='left_anti')

    # union back the INSERT/UPDATE rows (exclude DELETE rows if there were any)
    insert_update_rows = df_marker_surviving.filter((col('dd_op') == 'INSERT') | (col('dd_op') == 'UPDATE')).drop('dd_op')
    combined_df = existing_after_anti.unionByName(insert_update_rows, allowMissingColumns=True)

    # write the combined dataframe back to the same target path (overwrite)
    try:
        logger.info("Writing combined ZeroPremDrops target back to S3 (overwrite): %s", target_path)
        combined_df.write.mode('overwrite').parquet(target_path)
    except Exception as e_w:
        logger.error(f"Failed writing combined ZeroPremDrops target to S3: {e_w}", exc_info=True)
        raise

    # assign the node's output dataframe for downstream consumption
    df_Upd_RecDrop_Ind_optimistic_kant = df_marker_surviving.drop('dd_op')
except Exception as e:
    logger.error(f"Failed executing Update Strategy Upd_RecDrop_Ind: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Expression: EXP_Gen_Exceptions
# Compute REC_EXCPN_RSN_DESC and REC_EXCPN_IND based on available incoming columns
# -----------------------------------------------------------------------------
try:
    logger.info("Transform EXP_Gen_Exceptions: deriving REC_EXCPN_RSN_DESC and REC_EXCPN_IND")
    # build a string reason using available columns; avoid inventing non-existent columns
    df_temp = df_EXP_PassThrough_Src_dazzling_curie
    # ensure key exists
    if 'NISS_APRM_DETL_SK' not in df_temp.columns:
        df_temp = df_temp.withColumn('NISS_APRM_DETL_SK', lit(None))

    df_EXP_Gen_Exceptions_loving_faraday = (
        df_temp
        .withColumn('REC_EXCPN_RSN_DESC', concat_ws(' ', lit('EXC'), col('NISS_APRM_DETL_SK').cast('string')))
        .withColumn('REC_EXCPN_IND', when(trim(col('REC_EXCPN_RSN_DESC')) == '' , lit('')).otherwise(lit('Y')))
        .select('NISS_APRM_DETL_SK', 'REC_EXCPN_IND', 'REC_EXCPN_RSN_DESC')
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_Gen_Exceptions: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Expression: EXP_Gen_RecDrops
# Derive REC_DROP_RSN_DESC and REC_DROP_IND
# -----------------------------------------------------------------------------
try:
    logger.info("Transform EXP_Gen_RecDrops: deriving REC_DROP_RSN_DESC and REC_DROP_IND")
    df_temp2 = df_EXP_PassThrough_Src_dazzling_curie
    if 'NISS_APRM_DETL_SK' not in df_temp2.columns:
        df_temp2 = df_temp2.withColumn('NISS_APRM_DETL_SK', lit(None))

    df_EXP_Gen_RecDrops_eager_archimedes = (
        df_temp2
        .withColumn('REC_DROP_RSN_DESC', concat_ws(' ', lit('DRP'), col('NISS_APRM_DETL_SK').cast('string')))
        .withColumn('REC_DROP_IND', when(trim(col('REC_DROP_RSN_DESC')) == '', lit('')).otherwise(lit('Y')))
        .select('NISS_APRM_DETL_SK', 'REC_DROP_IND', 'REC_DROP_RSN_DESC')
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_Gen_RecDrops: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Expression: EXP_Dummy
# Combine pass-through master with REC_DROP and REC_EXCPN payloads via left joins
# -----------------------------------------------------------------------------
try:
    logger.info("Transform EXP_Dummy: left-join pass-through master with rec-drops and exceptions payloads")
    base_df = df_EXP_PassThrough_Src_dazzling_curie.alias('base')
    drops_df = df_EXP_Gen_RecDrops_eager_archimedes.alias('drops')
    excp_df = df_EXP_Gen_Exceptions_loving_faraday.alias('excp')

    joined = (
        base_df
        .join(drops_df, on=['NISS_APRM_DETL_SK'], how='left')
        .join(excp_df, on=['NISS_APRM_DETL_SK'], how='left')
        .select(
            col('NISS_APRM_DETL_SK'),
            col('REC_DROP_IND'),
            col('REC_DROP_RSN_DESC'),
            col('REC_EXCPN_IND'),
            col('REC_EXCPN_RSN_DESC')
        )
    )
    df_EXP_Dummy_affectionate_tesla = joined
except Exception as e:
    logger.error(f"Failed transforming EXP_Dummy: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Filter: FIL_OnlyExceptions_or_Drops
# Apply boolean filter REC_DROP_IND='Y' OR REC_EXCPN_IND='Y' and project specific ports
# -----------------------------------------------------------------------------
try:
    logger.info("Filtering only exceptions or drops in FIL_OnlyExceptions_or_Drops")
    df_FIL_OnlyExceptions_or_Drops_jolly_faraday = (
        df_EXP_Dummy_affectionate_tesla.filter(expr("REC_DROP_IND='Y' OR REC_EXCPN_IND='Y'"))
        .select('REC_DROP_RSN_DESC', 'NISS_APRM_DETL_SK', 'REC_DROP_IND', 'REC_EXCPN_IND', 'REC_EXCPN_RSN_DESC')
    )
except Exception as e:
    logger.error(f"Failed filtering FIL_OnlyExceptions_or_Drops: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Update Strategy: Upd_CVG_CD_SK
# Derive dd_op, drop REJECT rows, and apply load-modify-store-back to target WRK_BIRP_NISS_APRM_DETL
# -----------------------------------------------------------------------------
try:
    logger.info("Applying Update Strategy Upd_CVG_CD_SK: derive dd_op and apply load-modify-store-back to WRK_BIRP_NISS_APRM_DETL")
    df_marker2 = df_FIL_OnlyExceptions_or_Drops_jolly_faraday.withColumn('dd_op', lit('UPDATE'))
    df_marker2_surviving = df_marker2.filter(col('dd_op') != 'REJECT')

    target_path_cvg = f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    try:
        logger.info("Reading existing target for WRK_BIRP_NISS_APRM_DETL from %s", target_path_cvg)
        existing_df_cvg = spark.read.parquet(target_path_cvg)
    except Exception:
        logger.warning("Existing target WRK_BIRP_NISS_APRM_DETL not found on S3; starting from empty dataframe")
        existing_df_cvg = spark.createDataFrame([], df_marker2_surviving.drop('dd_op').schema)

    changed_keys_cvg = df_marker2_surviving.select('NISS_APRM_DETL_SK').distinct()
    existing_after_anti_cvg = existing_df_cvg.join(changed_keys_cvg, on='NISS_APRM_DETL_SK', how='left_anti')

    insert_update_rows_cvg = df_marker2_surviving.filter((col('dd_op') == 'INSERT') | (col('dd_op') == 'UPDATE')).drop('dd_op')
    combined_cvg = existing_after_anti_cvg.unionByName(insert_update_rows_cvg, allowMissingColumns=True)

    try:
        logger.info("Writing combined WRK_BIRP_NISS_APRM_DETL target back to S3 (overwrite): %s", target_path_cvg)
        combined_cvg.write.mode('overwrite').parquet(target_path_cvg)
    except Exception as e_w:
        logger.error(f"Failed writing combined WRK_BIRP_NISS_APRM_DETL target to S3: {e_w}", exc_info=True)
        raise

    # assign the node's output dataframe for downstream consumption
    df_Upd_CVG_CD_SK_daring_euclid = combined_cvg
except Exception as e:
    logger.error(f"Failed executing Update Strategy Upd_CVG_CD_SK: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops (not a flat file) -> write parquet to S3
# Input: df_Upd_RecDrop_Ind_optimistic_kant
# -----------------------------------------------------------------------------
# ensure the expected df_name assignment exists per plan
try:
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops_humble_maxwell = df_Upd_RecDrop_Ind_optimistic_kant
    logger.info("Assigned df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops_humble_maxwell from Upd_RecDrop_Ind output")
except Exception as e:
    logger.error(f"Failed assigning df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops_humble_maxwell: {e}", exc_info=True)
    raise

try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops to S3 as parquet (overwrite)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops_humble_maxwell.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL_ZeroPremDrops to S3: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL (final mapping output) -> write parquet to S3
# Input: df_Upd_CVG_CD_SK_daring_euclid
# -----------------------------------------------------------------------------
# ensure the expected df_name assignment exists per plan
try:
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_reverent_babbage = df_Upd_CVG_CD_SK_daring_euclid
    logger.info("Assigned df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_reverent_babbage from Upd_CVG_CD_SK output")
except Exception as e:
    logger.error(f"Failed assigning df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_reverent_babbage: {e}", exc_info=True)
    raise

try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL to S3 as parquet (overwrite)")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_reverent_babbage.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL to S3: {e}", exc_info=True)
    raise


job.commit()
