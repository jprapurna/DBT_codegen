{{ config(materialized='view') }}

WITH batch_ctrl AS (
    SELECT
        "SOURCE_NAME" AS source_name, -- Source name for batch control
        "BATCH_ID" AS batch_id,       -- Batch identifier
        "STATUS" AS status            -- Status of the batch
    FROM {{ source('CDM', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    source_name,
    batch_id,
    status
FROM batch_ctrl