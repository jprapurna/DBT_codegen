-- Purpose: Process batch ID using mapplet
WITH batch_id_data AS (
  SELECT 
    SOURCE_NAME, 
    BATCH_ID AS o_BATCH_ID 
  FROM {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
  SOURCE_NAME, 
  o_BATCH_ID 
FROM batch_id_data