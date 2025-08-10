-- Purpose: Connect and ingest data from cloud storage platforms like Amazon S3, Azure Blob, and Google Cloud Storage

WITH cloud_storage_data AS (
  SELECT
    s3_field AS amazon_s3_field,
    azure_blob_field AS azure_blob_field,
    gcs_field AS google_cloud_storage_field,
    COALESCE(expression_transformation(amazon_s3_field), 'default_value') AS normalized_s3_field,
    COALESCE(expression_transformation(azure_blob_field), 'default_value') AS normalized_blob_field,
    COALESCE(expression_transformation(google_cloud_storage_field), 'default_value') AS normalized_gcs_field
  FROM {{ source('Snowflake', 'cloud_storage_data') }}
)

SELECT
  amazon_s3_field,
  azure_blob_field,
  google_cloud_storage_field,
  normalized_s3_field,
  normalized_blob_field,
  normalized_gcs_field
FROM cloud_storage_data