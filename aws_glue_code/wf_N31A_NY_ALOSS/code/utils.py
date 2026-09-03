import json
import boto3


def get_snowflake_connection(secret_name):
    """Fetch this job's Snowflake JDBC connection details from AWS Secrets Manager."""
    secret = json.loads(boto3.client("secretsmanager").get_secret_value(SecretId=secret_name)["SecretString"])
    return secret["url"], secret["username"], secret["password"]


def read_staged_table_s3_first(spark, glueContext, table, s3_bucket, glue_database, select_expr=None, logger=None):
    """Attempt to read a staged parquet table from S3 first, falling back to the Glue Data Catalog.

    Parameters:
    - spark: SparkSession
    - glueContext: AWS GlueContext
    - table: table name (string)
    - s3_bucket: S3 bucket (string) where staged parquet lives (path s3://{s3_bucket}/{table}/)
    - glue_database: Glue database name (string) to use for catalog fallback
    - select_expr: optional selectExpr argument (string or list/tuple of expressions) to apply to the resulting DataFrame
    - logger: optional logger; if not provided, a module logger will be used

    Returns:
    - pyspark.sql.DataFrame

    Behavior mirrors the repeated pattern used in mappings: try S3 parquet read, if that fails log a warning and fall back to the Glue Catalog, raise on fatal errors.
    """
    import logging
    if logger is None:
        logger = logging.getLogger(__name__)
    try:
        logger.info("Attempting to read staged parquet for %s from S3", table)
        df = spark.read.parquet(f"s3://{s3_bucket}/{table}/")
        if select_expr is not None:
            # select_expr may be a single string (commonly a comma-separated or single selectExpr string)
            # or an iterable of column/expression strings. We attempt to handle both.
            if isinstance(select_expr, (list, tuple)):
                df = df.selectExpr(*select_expr)
            else:
                df = df.selectExpr(select_expr)
        return df
    except Exception as e:
        logger.warning("Staged parquet not found on S3, falling back to Glue Catalog: %s", str(e))
        try:
            # Try the two common GlueContext APIs that appear across generated scripts.
            try:
                dyf = glueContext.create_dynamic_frame.from_catalog(database=glue_database, table_name=table)
            except Exception:
                dyf = glueContext.create_dynamic_frame_from_catalog(database=glue_database, table_name=table)
            df = dyf.toDF()
            if select_expr is not None:
                if isinstance(select_expr, (list, tuple)):
                    df = df.selectExpr(*select_expr)
                else:
                    df = df.selectExpr(select_expr)
            return df
        except Exception as e2:
            logger.error("Failed reading %s from Glue Catalog: %s", table, e2, exc_info=True)
            raise
