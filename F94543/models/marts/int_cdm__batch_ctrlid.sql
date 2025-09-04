{{ config(materialized='ephemeral') }}

WITH batch_ctrlid AS (
  SELECT 
    BATCH_ID,
    SOURCE_NAME
  FROM {{ mplt_CDM_BATCH_ID('GWCDH') }}
)

SELECT * 
FROM batch_ctrlid