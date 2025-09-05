{{ config(materialized='view') }}

WITH target_table AS (
    SELECT
        "ROW_WID" AS row_wid -- Unique row identifier
    FROM {{ source('genai_power_bi', 'target_table') }}
)
SELECT
    row_wid
FROM target_table