-- Purpose: Represents the lookup transformation fetching max batch ID based on source name

WITH batch_data AS (
  SELECT 
    MAX(BATCH_ID) AS batch_id,
    LTRIM(RTRIM(SOURCE_NAME)) AS source_name
  FROM {{ source('GENAI_POWER_BI', 'LKP_CDM_BATCH_CTRLID') }}
  GROUP BY LTRIM(RTRIM(SOURCE_NAME))
)

SELECT 
  batch_id,
  source_name
FROM batch_data