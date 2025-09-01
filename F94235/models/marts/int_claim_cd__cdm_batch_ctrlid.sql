{{ config(materialized='ephemeral') }}

WITH batch_ctrlid_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = '{{ var("status_running") }}'
  GROUP BY SOURCE_NAME
)
SELECT * FROM batch_ctrlid_data