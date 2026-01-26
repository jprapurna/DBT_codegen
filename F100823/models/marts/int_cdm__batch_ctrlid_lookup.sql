{{
  config(materialized='ephemeral')
}}

WITH batch_ctrlid_lookup AS (
  SELECT 
    MAX(BATCH_ID) AS batch_id,
    TRIM(SOURCE_NAME) AS source_name
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
)

SELECT *
FROM batch_ctrlid_lookup