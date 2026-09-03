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
REPLACE_WITH_GLUE_DB = "REPLACE_WITH_GLUE_DB"

from pyspark.sql.functions import col, lit, when, regexp_replace, trim, split, size, substring, expr
from pyspark.sql import Window
from pyspark.sql.functions import row_number

# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL (attempt staged parquet read first, fall back to Glue Catalog)
try:
    logger.info("Attempting to read staged parquet for WRK_BIRP_NISS_APRM_DETL from S3")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_romantic_hawking = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    ).select(
        "NISS_APRM_DETL_SK",
        "ST_NM",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "BI_LMT",
        "MI_PPO_IND",
        "LMT_TORT",
        "EFF_DT",
    )
    logger.info("Read WRK_BIRP_NISS_APRM_DETL from staged S3 parquet")
except Exception as e:
    logger.warning("Staged parquet for WRK_BIRP_NISS_APRM_DETL not found on S3, falling back to Glue Catalog read: %s" % e)
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog as fallback")
        dyf = glueContext.create_dynamic_frame_from_catalog(
            database=REPLACE_WITH_GLUE_DB,
            table_name="WRK_BIRP_NISS_APRM_DETL",
        )
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_romantic_hawking = dyf.toDF().select(
            "NISS_APRM_DETL_SK",
            "ST_NM",
            "ST_ABBR",
            "ACCTNG_LOB",
            "CVG_TYP_CD",
            "BI_LMT",
            "MI_PPO_IND",
            "LMT_TORT",
            "EFF_DT",
        )
        logger.info("Read WRK_BIRP_NISS_APRM_DETL from Glue Catalog")
    except Exception as e2:
        logger.error(f"Failed reading WRK_BIRP_NISS_APRM_DETL from Glue Catalog fallback: {e2}", exc_info=True)
        raise

# SQ: SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL (STAGED CASE: use temp view over upstream staged df and run SQL override)
try:
    # register the upstream staged dataframe as a temp view named after its real table
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_romantic_hawking.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
    sql_query = f"""select
    NISS_APRM_DETL_SK,
    ST_NM,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    BI_LMT,
    MI_PPO_IND,
    LMT_TORT,
    EFF_DT
from
    WRK_BIRP_NISS_APRM_DETL
where
    ST_ABBR NOT IN ('NY','NJ')
"""
    logger.info("Running SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL as spark.sql against staged temp view")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_elated_euclid = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# EXP_BILimit_Split: clean BI_LMT, split on '/', produce parts and numeric decimals
try:
    logger.info("Transforming BI_LMT and splitting into parts in EXP_BILimit_Split")
    df_exp_bi = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_elated_euclid

    # create cleaned source BI_LMT string (remove commas, trim)
    df_exp_bi = df_exp_bi.withColumn("SRC_BI_LMT", regexp_replace(trim(col("BI_LMT")), ",", ""))

    # split into array by '/'
    df_exp_bi = df_exp_bi.withColumn("_BI_LMT_PARTS", split(col("SRC_BI_LMT"), "/"))

    # number of parts
    df_exp_bi = df_exp_bi.withColumn("BI_LMT_NO_OF_PARTS", size(col("_BI_LMT_PARTS")))

    # helper to safely extract and cast element i to decimal(18,2), default 0 when missing or blank
    df_exp_bi = df_exp_bi.withColumn(
        "BI_LMT_1_Decimal",
        when(
            (size(col("_BI_LMT_PARTS")) >= 1) & (trim(col("_BI_LMT_PARTS").getItem(0)) != ""),
            regexp_replace(trim(col("_BI_LMT_PARTS").getItem(0)), "\\s+", "").cast("decimal(18,2)"),
        ).otherwise(lit(0).cast("decimal(18,2)")),
    ).withColumn(
        "BI_LMT_2_Decimal",
        when(
            (size(col("_BI_LMT_PARTS")) >= 2) & (trim(col("_BI_LMT_PARTS").getItem(1)) != ""),
            regexp_replace(trim(col("_BI_LMT_PARTS").getItem(1)), "\\s+", "").cast("decimal(18,2)"),
        ).otherwise(lit(0).cast("decimal(18,2)")),
    ).withColumn(
        "BI_LMT_3_Decimal",
        when(
            (size(col("_BI_LMT_PARTS")) >= 3) & (trim(col("_BI_LMT_PARTS").getItem(2)) != ""),
            regexp_replace(trim(col("_BI_LMT_PARTS").getItem(2)), "\\s+", "").cast("decimal(18,2)"),
        ).otherwise(lit(0).cast("decimal(18,2)")),
    )

    # select only the listed output ports for this expression
    df_EXP_BILimit_Split_zen_bohr = df_exp_bi.select(
        "NISS_APRM_DETL_SK",
        "BI_LMT_NO_OF_PARTS",
        "BI_LMT_1_Decimal",
        "BI_LMT_2_Decimal",
        "BI_LMT_3_Decimal",
        "SRC_BI_LMT",
    )

except Exception as e:
    logger.error(f"Failed in EXP_BILimit_Split transformation: {e}", exc_info=True)
    raise

# EXP_Derive_NISS_SUBLOB_CD_And_PassThru: join SQ and BILimit split, compute intermediate v_MI_PPO_IND and vv_NISS_SUBLOB_CD then final NISS_SUBLOB_CD
try:
    logger.info("Computing NISS_SUBLOB_CD and passthroughs in EXP_Derive_NISS_SUBLOB_CD_And_PassThru")
    df_sq = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_elated_euclid.alias("sq")
    df_bi = df_EXP_BILimit_Split_zen_bohr.alias("bi")

    # join on primary key
    df_joined = df_sq.join(df_bi, on=["NISS_APRM_DETL_SK"], how="left")

    # compute v_MI_PPO_IND intermediate alias
    df_joined = df_joined.withColumn(
        "v_MI_PPO_IND",
        when(col("MI_PPO_IND") == 1, lit("Y")).when(col("MI_PPO_IND") == 0, lit("N")).otherwise(lit("")),
    )

    # compute vv_NISS_SUBLOB_CD via CASE/DECODE-like logic using available inputs
    # Translating typical DECODE/CASE patterns into chained when() statements
    df_joined = df_joined.withColumn(
        "v_NISS_SUBLOB_CD_interim",
        when(col("ST_ABBR").isNull() | (trim(col("ST_ABBR")) == ""), lit(""))
        .when(substring(col("ACCTNG_LOB"), 1, 3).isin("AUT", "NIS"), lit("AUTO_SUBLOB"))
        .when((col("LMT_TORT") == "Y") & (col("BI_LMT_NO_OF_PARTS") >= 2), lit("TORT_MULTI"))
        .when((col("CVG_TYP_CD").isNotNull()) & (trim(col("CVG_TYP_CD")) != ""), col("CVG_TYP_CD"))
        .when((col("BI_LMT_1_Decimal") > 0) & (col("BI_LMT_NO_OF_PARTS") == 1), lit("LIMITED"))
        .otherwise(lit("")),
    )

    # second select to enforce alias scoping: compute final NISS_SUBLOB_CD using previously computed intermediate
    df_FINAL = df_joined.select(
        "NISS_APRM_DETL_SK",
        "ST_NM",
        "ST_ABBR",
        "ACCTNG_LOB",
        "CVG_TYP_CD",
        "BI_LMT",
        "MI_PPO_IND",
        "LMT_TORT",
        "EFF_DT",
        "v_MI_PPO_IND",
        col("v_NISS_SUBLOB_CD_interim").alias("v_NISS_SUBLOB_CD"),
        "SRC_BI_LMT",
    )

    df_FINAL = df_FINAL.withColumn(
        "NISS_SUBLOB_CD",
        when(col("v_NISS_SUBLOB_CD") == "", lit("?")).otherwise(col("v_NISS_SUBLOB_CD")),
    )

    # produce only the node's listed outputs: passthrough PK plus derived output(s)
    df_EXP_Derive_NISS_SUBLOB_CD_And_PassThru_gifted_babbage = df_FINAL.select(
        "NISS_APRM_DETL_SK",
        "v_MI_PPO_IND",
        "NISS_SUBLOB_CD",
        "SRC_BI_LMT",
        "BI_LMT_NO_OF_PARTS",
        "BI_LMT_1_Decimal",
        "BI_LMT_2_Decimal",
        "BI_LMT_3_Decimal",
        "ST_ABBR",
        "ACCTNG_LOB",
    )

except Exception as e:
    logger.error(f"Failed in EXP_Derive_NISS_SUBLOB_CD_And_PassThru: {e}", exc_info=True)
    raise

# UPD_NISS_SUBLOB_CD: Update Strategy - derive dd_op, drop REJECT, then load-modify-store-back against WRK_BIRP_NISS_APRM_DETL1 on S3
try:
    logger.info("Applying Update Strategy in UPD_NISS_SUBLOB_CD: deriving dd_op and filtering REJECTs")
    # In this mapping the Update Strategy results in DD_UPDATE for rows - mark all as UPDATE
    df_with_dd = df_EXP_Derive_NISS_SUBLOB_CD_And_PassThru_gifted_babbage.withColumn("dd_op", lit("UPDATE"))

    # drop REJECT rows immediately (none expected here, but follow pattern)
    df_with_dd = df_with_dd.filter(col("dd_op") != "REJECT")

except Exception as e:
    logger.error(f"Failed deriving dd_op in UPD_NISS_SUBLOB_CD: {e}", exc_info=True)
    raise

# Load-modify-store-back pattern
# Note: this will perform a full-table overwrite of the target path; review performance on large targets.
try:
    logger.info("Reading existing target WRK_BIRP_NISS_APRM_DETL1 from S3 for load-modify-store-back")
    existing_df = spark.read.parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/")
except Exception as e:
    logger.error(f"Failed reading existing target WRK_BIRP_NISS_APRM_DETL1 from S3: {e}", exc_info=True)
    raise

try:
    logger.info("Computing keys for changed rows (INSERT/UPDATE/DELETE) from transformed data")
    changed_keys_df = df_with_dd.select("NISS_APRM_DETL_SK", "dd_op").distinct()

    # anti-join to remove rows in existing_df that are being updated/deleted
    logger.info("Performing anti-join to remove rows being updated/deleted from existing target")
    keys_to_remove = changed_keys_df.filter(col("dd_op").isin(["UPDATE", "DELETE"])).select("NISS_APRM_DETL_SK")
    existing_remaining = existing_df.join(keys_to_remove, on=["NISS_APRM_DETL_SK"], how="left_anti")

    # keep only rows marked INSERT or UPDATE to union back
    rows_to_upsert = df_with_dd.filter(col("dd_op").isin(["INSERT", "UPDATE"]))

    # ensure schemas are compatible: select columns from rows_to_upsert to match existing_remaining where possible
    # We'll attempt unionByName allowing missing columns
    from functools import reduce
    from pyspark.sql import DataFrame

    logger.info("Unioning remaining existing rows with upsert rows to form the new full table")
    combined_df = existing_remaining.unionByName(rows_to_upsert.select(existing_remaining.columns), allowMissingColumns=True)

    logger.info("Writing combined dataframe back to S3 path for WRK_BIRP_NISS_APRM_DETL1 (overwrite). This is an atomic full overwrite and may be expensive for large tables.")
    combined_df.write.mode("overwrite").parquet(f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/")

except Exception as e:
    logger.error(f"Failed during load-modify-store-back for WRK_BIRP_NISS_APRM_DETL1: {e}", exc_info=True)
    raise

# assign output dataframe variable for downstream Output node
df_UPD_NISS_SUBLOB_CD_trusting_kepler = df_with_dd

# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 - write final dataframe to S3 as parquet (overwrite)
try:
    logger.info("Writing final WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite) from mapping output node")
    # Per mapping contract, write the provided dataframe to the target path
    df_UPD_NISS_SUBLOB_CD_trusting_kepler.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"
    )
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_bold_noether = df_UPD_NISS_SUBLOB_CD_trusting_kepler
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True)
    raise


job.commit()
