{{ config(materialized='view') }}

WITH lkp_cdm_batch_ctrlid AS (
    SELECT
        -- No columns available for aliasing
    FROM {{ source('GENAI_POWER_BI', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    -- No columns available for selection
FROM lkp_cdm_batch_ctrlid