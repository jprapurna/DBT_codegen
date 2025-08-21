-- Purpose: Lookup transformation to fetch the maximum batch ID and source name from the table CDM.CDM_BATCH_CTRLID

WITH batch_data AS (
  SELECT 
    BATCH_ID AS batch_id,
    SOURCE_NAME AS source_name
  FROM {{ source('CDH_GWODS', 'lkp_CDM_BATCH_CTRLID') }}
)

SELECT 
  batch_id,
  source_name
FROM batch_data
WHERE source_name = '{{ var("SOURCE_NAME_GWCDM") }}'