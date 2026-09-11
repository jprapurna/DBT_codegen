import json
import boto3


def get_snowflake_connection(secret_name):
    """Fetch this job's Snowflake JDBC connection details from AWS Secrets Manager."""
    secret = json.loads(boto3.client("secretsmanager").get_secret_value(SecretId=secret_name)["SecretString"])
    return secret["url"], secret["username"], secret["password"]


def read_staged_or_catalog(spark, glueContext, s3_bucket, glue_database, table_name, logger):
    """Try to read a staging WRK_ table from s3 first, and fall back to Glue Catalog if missing.
    Returns a Spark DataFrame with the expected projected columns.
    """
    try:
        logger.info(f"Attempting to read {table_name} from S3 parquet")
        return spark.read.parquet(f"s3://{s3_bucket}/{table_name}/")
    except Exception as e:
        logger.warning(f"S3 read failed for {table_name}, falling back to Glue Catalog: {e}")
        dyf = glueContext.create_dynamic_frame_from_catalog(database=glue_database, table_name=table_name)
        return dyf.toDF()


def write_intermediate_parquet(df, s3_bucket, target_table, logger):
    """Write an intermediate WRK_ table to S3 as parquet with overwrite and standardized logging."""
    try:
        logger.info(f"Writing {target_table} to S3 as parquet (overwrite)")
        df.write.mode("overwrite").parquet(f"s3://{s3_bucket}/{target_table}/")
        logger.info(f"Successfully wrote {target_table} to S3")
    except Exception as e:
        logger.error(f"Failed writing {target_table} to S3: {e}", exc_info=True)
        raise
