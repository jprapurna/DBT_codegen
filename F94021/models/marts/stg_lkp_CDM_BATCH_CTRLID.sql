{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'lkp_CDM_BATCH_CTRLID') }}
)
SELECT
    *
FROM source_data