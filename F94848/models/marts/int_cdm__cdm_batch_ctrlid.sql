{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID, 
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = $$STATUS_RUNNING
  GROUP BY SOURCE_NAME
)
SELECT *
FROM source_data