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

from pyspark.sql.functions import col, expr, lit, trim, coalesce
from pyspark.sql.window import Window
from pyspark.sql.functions import row_number

# -----------------------------------------------------------------------------
# Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL -> df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_adoring_curie
# This is a WRK_ intermediate source so prefer staged parquet on S3 first and
# register as a temp view named 'WRK_BIRP_NISS_APRM_DETL' for downstream SQL override.
# -----------------------------------------------------------------------------
try:
    logger.info("Attempting to read staged parquet for WRK_BIRP_NISS_APRM_DETL from S3")
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_adoring_curie = spark.read.parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL/"
    )
    # register temp view for any downstream SQL-overrides that expect this staged table
    try:
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_adoring_curie.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
    except Exception:
        # non-fatal: view registration best-effort
        logger.warning("Could not create temp view WRK_BIRP_NISS_APRM_DETL after reading staged parquet")
except Exception as e:
    # Fall back to Glue Catalog read (or other source) if staged parquet is not available
    logger.warning(f"Staged parquet for WRK_BIRP_NISS_APRM_DETL not found or unreadable, falling back to Glue Catalog: {e}")
    try:
        logger.info("Reading WRK_BIRP_NISS_APRM_DETL from Glue Data Catalog")
        # use the real table name (strip FDR_LIB_ prefix) -> WRK_BIRP_NISS_APRM_DETL
        dyf = glueContext.create_dynamic_frame.from_catalog(database=GLUE_DATABASE, table_name="WRK_BIRP_NISS_APRM_DETL")
        df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_adoring_curie = dyf.toDF()
        # also register as temp view so the SQL override can run against it
        try:
            df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_adoring_curie.createOrReplaceTempView("WRK_BIRP_NISS_APRM_DETL")
        except Exception:
            logger.warning("Could not create temp view WRK_BIRP_NISS_APRM_DETL after reading from Glue Catalog")
    except Exception as e2:
        logger.error(f"Failed to read WRK_BIRP_NISS_APRM_DETL from both staged parquet and Glue Catalog: {e2}", exc_info=True)
        raise

# -----------------------------------------------------------------------------
# Application Source Qualifier: SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL
# This SQ has a SQL override against FDR.WRK_BIRP_NISS_APRM_DETL and the upstream
# staged table is available; rewrite the override to select from the temp view.
# -----------------------------------------------------------------------------
sql_query = f"""select
    AGE,
    MILES_TO_WRK,
    AUTO_USE_CD,
    NISS_APRM_DETL_SK,
    REC_EXCP_DESC,
    REC_EXCPN_IND
from
    WRK_BIRP_NISS_APRM_DETL
"""

try:
    logger.info("Executing rewritten SQL override for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL against temp view WRK_BIRP_NISS_APRM_DETL")
    df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_lucid_hilbert = spark.sql(sql_query)
except Exception as e:
    logger.error(f"Failed executing SQL for SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Expression: EXP_To_Drv_Class_Cd1
# First compute intermediate aliases (I_AUTO_USE_CD, IAGE, IMILES_TO_WRK), then
# compute final outputs referencing those intermediates.
# -----------------------------------------------------------------------------
try:
    logger.info("Transforming EXP_To_Drv_Class_Cd1: computing intermediates and final ports")
    # First projection: compute intermediate columns. List every upstream column explicitly.
    df_EXP_intermediate_happy_planck = df_SQ_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_lucid_hilbert.selectExpr(
        "AGE",
        "MILES_TO_WRK",
        "AUTO_USE_CD",
        "NISS_APRM_DETL_SK",
        "REC_EXCP_DESC",
        "REC_EXCPN_IND",
        "COALESCE(TRIM(AUTO_USE_CD), '') AS I_AUTO_USE_CD",
        "CAST(AGE AS INT) AS IAGE",
        "CAST(MILES_TO_WRK AS INT) AS IMILES_TO_WRK"
    )

    # Second projection: derive final ports using the intermediates above. Every output column
    # is listed explicitly; reuse intermediate aliases by referencing them directly.
    df_EXP_To_Drv_Class_Cd1_happy_planck = df_EXP_intermediate_happy_planck.selectExpr(
        # derived NISS_CLASS_CD: translate Informatica DECODE/IIF patterns to CASE WHEN
        "CASE \
            WHEN I_AUTO_USE_CD = '' THEN 'UNKNOWN' \
            WHEN IAGE IS NULL THEN NULL \
            WHEN IAGE < 25 THEN 'Y' \
            ELSE 'N' \
         END AS NISS_CLASS_CD",
        # passthrough primary key
        "NISS_APRM_DETL_SK",
        # passthrough exception description/indicator
        "REC_EXCP_DESC",
        "REC_EXCPN_IND"
    )
except Exception as e:
    logger.error(f"Failed transforming EXP_To_Drv_Class_Cd1: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Update Strategy: UPD_NISS_CLASS_CD
# Derive dd_op, drop REJECT rows, and apply load-modify-store-back against
# s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/ using NISS_APRM_DETL_SK as PK.
# -----------------------------------------------------------------------------
try:
    logger.info("Applying Update Strategy UPD_NISS_CLASS_CD: deriving dd_op and applying load-modify-store-back against WRK_BIRP_NISS_APRM_DETL1")
    # mark every incoming row as UPDATE per mapping plan
    df_with_dd = df_EXP_To_Drv_Class_Cd1_happy_planck.withColumn("dd_op", lit("UPDATE"))

    # drop REJECT rows immediately
    df_surviving = df_with_dd.filter(col("dd_op") != "REJECT")

    # primary key dataframe for changed rows
    changed_keys_df = df_surviving.select("NISS_APRM_DETL_SK").dropDuplicates()

    target_path = f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"

    # load current full target; if missing, treat as empty table
    try:
        logger.info(f"Reading current full target for WRK_BIRP_NISS_APRM_DETL1 from {target_path}")
        existing_df = spark.read.parquet(target_path)
    except Exception as e_read:
        logger.warning(f"Target parquet at {target_path} not found or unreadable; treating as empty existing set: {e_read}")
        # create an empty DataFrame with the same schema as df_surviving to allow union
        existing_df = spark.createDataFrame(spark.sparkContext.emptyRDD(), df_surviving.schema)

    # anti-join to remove rows from existing target that are being updated/deleted
    remaining_existing = existing_df.join(changed_keys_df, on="NISS_APRM_DETL_SK", how="left_anti")

    # union remaining existing rows with INSERT/UPDATE rows from surviving change set
    rows_to_union = df_surviving.filter(col("dd_op").isin("INSERT", "UPDATE"))

    combined_df = remaining_existing.unionByName(rows_to_union, allowMissingColumns=True)

    # write full combined table back to the same target path (overwrite)
    # NOTE: this full-target overwrite can be expensive for large tables.
    try:
        logger.info(f"Writing combined target for WRK_BIRP_NISS_APRM_DETL1 to {target_path} (overwrite)")
        combined_df.write.mode("overwrite").parquet(target_path)
    except Exception as e_write:
        logger.error(f"Failed writing combined target for WRK_BIRP_NISS_APRM_DETL1: {e_write}", exc_info=True)
        raise

    # Expose the post-apply full-table dataframe as this node's output so downstream Output
    # node can also write the mapping-declared artifact (keeps lineage explicit).
    df_UPD_NISS_CLASS_CD_admiring_noether = combined_df

except Exception as e:
    logger.error(f"Failed applying Update Strategy UPD_NISS_CLASS_CD: {e}", exc_info=True)
    raise

# -----------------------------------------------------------------------------
# Output: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1 -> write final parquet to S3
# -----------------------------------------------------------------------------
try:
    logger.info("Writing WRK_BIRP_NISS_APRM_DETL1 to S3 as parquet (overwrite)")
    # Final mapping target write
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_hopeful_galileo = df_UPD_NISS_CLASS_CD_admiring_noether
    df_FDR_LIB_WRK_BIRP_NISS_APRM_DETL1_hopeful_galileo.write.mode("overwrite").parquet(
        f"s3://{S3_OUTPUT_BUCKET}/WRK_BIRP_NISS_APRM_DETL1/"
    )
except Exception as e:
    logger.error(f"Failed writing WRK_BIRP_NISS_APRM_DETL1 to S3: {e}", exc_info=True)
    raise


job.commit()
