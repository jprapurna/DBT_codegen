{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    *
FROM source_data