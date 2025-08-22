{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SOURCE_NAME" AS source_name, -- Source name
        "BATCH_ID" AS batch_id       -- Batch ID
    FROM {{ source('CDM', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    source_name,
    batch_id
FROM source_data