{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Source name
"BATCH_ID" AS batch_id, -- Batch identifier
"STATUS" AS status -- Status of the batch
FROM {{ source('GENAI_POWER_BI', 'LKP_CDM_BATCH_CTRLID') }}