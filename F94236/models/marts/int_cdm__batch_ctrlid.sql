{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID, 
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('GENAI_POWER_BI', 'LKP_CDM_BATCH_CTRLID') }}
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
)

SELECT * 
FROM source_data