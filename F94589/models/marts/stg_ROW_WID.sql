{{ config(materialized='view') }}

WITH row_wid_table AS (
    SELECT
        "ROW_WID" AS row_wid -- Unique row identifier
    FROM {{ source('genai_power_bi', 'ROW_WID') }}
)
SELECT
    row_wid
FROM row_wid_table