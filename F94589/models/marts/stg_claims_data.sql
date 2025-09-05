{{ config(materialized='view') }}

WITH claims_data AS (
    SELECT
        "ROW_WID" AS row_wid -- Unique row identifier
    FROM {{ source('genai_power_bi', 'claims_data') }}
)
SELECT
    row_wid
FROM claims_data