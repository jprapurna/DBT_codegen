-- Purpose: Check for null values in BATCH_ID
WITH null_check_data AS (
  SELECT 
    BATCH_ID, 
    SOURCE_NAME, 
    IIF(ISNULL(LKP_BATCH_ID), -999, LKP_BATCH_ID) AS o_batch_id
  FROM {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
  BATCH_ID, 
  SOURCE_NAME, 
  o_batch_id
FROM null_check_data