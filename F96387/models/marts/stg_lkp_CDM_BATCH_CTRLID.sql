{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Source name for batch control
"BATCH_ID" AS batch_id -- Batch ID
FROM {{ source('IICS', 'lkp_CDM_BATCH_CTRLID') }}