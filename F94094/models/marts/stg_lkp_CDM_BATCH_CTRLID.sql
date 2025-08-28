{{ config(materialized='view') }}

WITH batch_ctrl AS (
    SELECT
        "BATCH_ID" AS batch_id,       -- Batch ID
        "SOURCE_NAME" AS source_name  -- Source name
    FROM {{ source('CDM', 'lkp_CDM_BATCH_CTRLID') }}
)
SELECT
    batch_id,
    source_name
FROM batch_ctrl