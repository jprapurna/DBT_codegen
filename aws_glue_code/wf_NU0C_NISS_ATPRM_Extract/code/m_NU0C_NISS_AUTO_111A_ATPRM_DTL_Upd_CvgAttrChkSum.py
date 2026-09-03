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

# Mapping: m_NU0C_NISS_AUTO_111A_ATPRM_DTL_Upd_CvgAttrChkSum
# No nodes were provided in the MappingIndex plan for this mapping; nothing to read, transform, or write.
# This script intentionally performs no data operations. The job will start and then complete.
try:
    logger.info("Mapping 'm_NU0C_NISS_AUTO_111A_ATPRM_DTL_Upd_CvgAttrChkSum' has no nodes to process")
except Exception as e:
    logger.error(f"Unexpected error while logging startup for mapping m_NU0C_NISS_AUTO_111A_ATPRM_DTL_Upd_CvgAttrChkSum: {e}", exc_info=True)
    raise


job.commit()
