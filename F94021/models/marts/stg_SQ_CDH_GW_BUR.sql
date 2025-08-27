{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}
)
SELECT
    *
FROM source_data