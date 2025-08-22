-- Purpose: Retrieves the maximum batch ID and trims the source name.
SELECT 
  MAX(BATCH_ID) AS BATCH_ID, 
  LTRIM(RTRIM(SOURCE_NAME)) AS SOURCE_NAME
FROM {{ source('CDM', 'LKP_CDM_BATCH_CTRLID') }}
WHERE STATUS = 'RUNNING'
GROUP BY SOURCE_NAME