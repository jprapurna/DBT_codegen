{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "BATCH_ID" AS batch_id,       -- Batch ID for the lookup
        "SOURCE_NAME" AS source_name  -- Source name for the batch
    FROM {{ source('genai_power_bi', 'lkp_cdm_batch_ctrlid') }}
)
SELECT
    batch_id,
    source_name
FROM source_data