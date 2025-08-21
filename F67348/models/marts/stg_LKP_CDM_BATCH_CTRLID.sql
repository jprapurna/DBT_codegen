{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SOURCE_NAME" AS source_name, -- Source name for the batch
        "BATCH_ID" AS batch_id,       -- Batch identifier
        "STATUS" AS status            -- Status of the batch
    FROM {{ source('CDM_BATCH_CTRLID', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    source_name,
    batch_id,
    status
FROM source_data