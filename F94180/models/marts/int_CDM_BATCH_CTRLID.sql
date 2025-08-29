-- Purpose: Retrieves the maximum batch ID for the incoming source name using a lookup query.
SELECT 
  MAX(BATCH_ID) AS BATCH_ID,
  LTRIM(RTRIM(SOURCE_NAME)) AS SOURCE_NAME
FROM {{ source('CDM', 'DUMMY_mplt_CDM_BATCH_ID_lkp_CDM_BATCH_CTRLID') }}
WHERE STATUS = 'RUNNING'
GROUP BY SOURCE_NAME