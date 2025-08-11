{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Name of the source
"BATCH_ID" AS batch_id -- Batch identifier
FROM {{ source('genai_power_bi', 'LKP_CDM_BATCH_CTRLID') }}