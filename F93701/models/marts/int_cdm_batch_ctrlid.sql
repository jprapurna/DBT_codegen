-- Purpose: Retrieves the maximum batch ID and trims the source name from the table CDM.CDM_BATCH_CTRLID.
WITH source_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    LTRIM(RTRIM(SOURCE_NAME)) AS SOURCE_NAME
  FROM {{ source('genai_power_bi', 'LKP_CDM_BATCH_CTRLID') }}
  GROUP BY SOURCE_NAME
)
SELECT * FROM source_data