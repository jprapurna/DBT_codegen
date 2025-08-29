{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        BATCH_ID AS batch_id,       -- Batch ID
        SOURCE_NAME AS source_name  -- Source name
    FROM {{ source('CDM', 'DUMMY_mplt_CDM_BATCH_ID_lkp_CDM_BATCH_CTRLID') }}
)
SELECT
    batch_id,
    source_name
FROM source_data