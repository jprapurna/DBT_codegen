{{ config(materialized='view') }}

WITH batch_ctrl AS (
    SELECT
        "SOURCE_NAME" AS source_name, -- Name of the source
        "BATCH_ID" AS batch_id,       -- Batch identifier
        "STATUS" AS status            -- Status of the batch
    FROM {{ source('genai_power_bi', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    source_name,
    batch_id,
    status
FROM batch_ctrl