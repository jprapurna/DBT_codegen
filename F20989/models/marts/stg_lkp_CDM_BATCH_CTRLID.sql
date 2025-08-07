{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Name of the source
"BATCH_ID" AS batch_id -- Identifier for the batch
FROM {{ source('genai_power_bi', 'lkp_CDM_BATCH_CTRLID') }}