{{ config(materialized='view') }}

WITH business_unit_relationships AS (
    SELECT
        "ROW_WID" AS row_wid -- Unique row identifier
    FROM {{ source('genai_power_bi', 'business_unit_relationships') }}
)
SELECT
    row_wid
FROM business_unit_relationships