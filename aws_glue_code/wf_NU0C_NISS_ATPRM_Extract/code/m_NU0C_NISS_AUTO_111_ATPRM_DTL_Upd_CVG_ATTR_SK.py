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

# Mapping: m_NU0C_NISS_AUTO_111_ATPRM_DTL_Upd_CVG_ATTR_SK
# Breadth-first node list is empty for this mapping; there are no Source/Transform/Output nodes to process.
# The bootstrap above has already initialized sc, glueContext, spark, job, logger, and Snowflake secrets.
try:
    logger.info("No nodes to process for mapping 'm_NU0C_NISS_AUTO_111_ATPRM_DTL_Upd_CVG_ATTR_SK'")
except Exception as e:
    logger.error(f"Unexpected error while validating empty mapping: {e}", exc_info=True)
    raise


job.commit()
