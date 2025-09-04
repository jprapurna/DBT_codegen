{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT *
  FROM {{ ref('int_claims__cdm_batch_ctrlid') }}
),

batch_id AS (
  SELECT
    SOURCE_NAME,
    BATCH_ID,
    STATUS
  FROM source_data
)

SELECT *
FROM batch_id