{{ config(materialized='view') }}

WITH lkp_cdm_batch_ctrlid AS (
    SELECT
        source_name AS source_name, -- Name of the source
        batch_id AS batch_id,       -- Batch identifier
        status AS status            -- Status of the batch
    FROM {{ source('DBA_COMMON_UTILS', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    source_name,
    batch_id,
    status
FROM lkp_cdm_batch_ctrlid