-- Purpose: Fetch max batch ID based on source name.
WITH cdm_batch_ctrlid AS (
  SELECT 
    MAX(BATCH_ID) AS batch_id,
    LTRIM(RTRIM(SOURCE_NAME)) AS source_name
  FROM {{ source('DBConnection_CDM', 'CDM_BATCH_CTRLID') }}
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
)
SELECT 
  batch_id,
  source_name
FROM cdm_batch_ctrlid