{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Source name
"BATCH_ID" AS batch_id -- Batch ID
FROM {{ source('IICS', 'LKP_CDM_BATCH_CTRLID') }}