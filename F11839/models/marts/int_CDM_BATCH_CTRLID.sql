-- Purpose: Fetch max batch ID based on source name
WITH batch_data AS (
  SELECT 
    MAX(BATCH_ID) AS batch_id, 
    LTRIM(RTRIM(SOURCE_NAME)) AS source_name
  FROM 
    {{ source('W_CLAIM_CD_SCD3_IU', 'lkp_CDM_BATCH_CTRLID') }}
  WHERE 
    STATUS = 'RUNNING'
  GROUP BY 
    SOURCE_NAME
)
SELECT 
  batch_id, 
  source_name
FROM 
  batch_data