-- Purpose: Process batch ID using mapplet
WITH batch_id_data AS (
  SELECT 
    SOURCE_NAME, 
    -- Assuming mapplet logic exists here
    'o_BATCH_ID' AS o_batch_id
  FROM {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
  SOURCE_NAME, 
  o_batch_id
FROM batch_id_data