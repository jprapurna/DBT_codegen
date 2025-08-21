-- Purpose: Fetch max batch ID based on source name from CDM_BATCH_CTRLID
WITH batch_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    LTRIM(RTRIM(SOURCE_NAME)) AS SOURCE_NAME
  FROM {{ source('CDM', 'LKP_CDM_BATCH_CTRLID') }}
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
)
SELECT * FROM batch_data