{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Name of the source
"BATCH_ID" AS batch_id -- Batch ID
FROM {{ source('CLAIM_DATA', 'lkp_CDM_BATCH_CTRLID') }}