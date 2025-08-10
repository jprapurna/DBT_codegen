-- Purpose: Load curated tables into Snowflake, Redshift, or BigQuery

WITH cloud_data_warehouse AS (
  SELECT
    a.sf_field,
    b.amazon_s3_field,
    c.oracle_field,
    d.kafka_topic_field
  FROM {{ ref('int_cloud_application_data') }} AS a
  JOIN {{ ref('int_cloud_storage_data') }} AS b ON a.key = b.key
  JOIN {{ ref('int_on_premise_data') }} AS c ON a.key = c.key
  JOIN {{ ref('int_streaming_data') }} AS d ON a.key = d.key
)

SELECT
  sf_field,
  amazon_s3_field,
  oracle_field,
  kafka_topic_field
FROM cloud_data_warehouse