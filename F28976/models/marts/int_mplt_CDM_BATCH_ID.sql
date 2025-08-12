-- Purpose: Mapplet transformation for batch ID processing
WITH mapplet_data AS (
  SELECT 
    SOURCE_NAME, 
    BATCH_ID AS o_BATCH_ID 
  FROM {{ ref('int_CDM_BATCH_CTRLID') }}
)
SELECT 
  SOURCE_NAME, 
  o_BATCH_ID 
FROM mapplet_data