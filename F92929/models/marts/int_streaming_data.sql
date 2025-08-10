-- Purpose: Stream data from Kafka topics and real-time event streams

WITH streaming_data AS (
  SELECT
    kafka_field AS kafka_topic_field,
    COALESCE(expression_transformation(kafka_topic_field), 'default_value') AS normalized_kafka_field
  FROM {{ source('Snowflake', 'streaming_data') }}
)

SELECT
  kafka_topic_field,
  normalized_kafka_field
FROM streaming_data