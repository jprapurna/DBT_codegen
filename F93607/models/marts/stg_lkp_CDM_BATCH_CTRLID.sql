{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Source name for the batch
"BATCH_ID" AS batch_id, -- Batch ID
"STATUS" AS status -- Status of the batch
FROM {{ source('CDH_GWODS', 'lkp_CDM_BATCH_CTRLID') }}