{{ config(materialized='view') }}

WITH lkp_cdm_batch_ctrlid AS (
    SELECT
        "SOURCE_NAME" AS source_name, -- Source name for the batch
        "BATCH_ID" AS batch_id,       -- Batch identifier
        "STATUS" AS status            -- Status of the batch
    FROM {{ source('cdm_batch_ctrlid', 'lkp_cdm_batch_ctrlid') }}
)
SELECT
    source_name,
    batch_id,
    status
FROM lkp_cdm_batch_ctrlid