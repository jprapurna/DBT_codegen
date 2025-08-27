{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'lkp_MAX_ROW_WID') }}
)
SELECT
    *
FROM source_data