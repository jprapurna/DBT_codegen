{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'tblSF_CaseHistory_Import') }}
)
SELECT
    *
FROM source_data