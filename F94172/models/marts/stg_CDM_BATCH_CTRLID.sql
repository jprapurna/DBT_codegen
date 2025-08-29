{{ config(materialized='view') }}

WITH cdm_batch_ctrlid AS (
    SELECT
        "BATCH_ID" AS batch_id,         -- Batch identifier
        "SOURCE_NAME" AS source_name    -- Source name for the batch
    FROM {{ source('CDM_BATCH_CTRLID', 'CDM_BATCH_CTRLID') }}
)
SELECT
    batch_id,
    source_name
FROM cdm_batch_ctrlid