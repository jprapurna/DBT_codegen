{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Row identifier
        "TABLE_NAME" AS table_name    -- Name of the table
    FROM {{ source('genai_power_bi', 'lkp_max_row_wid') }}
)
SELECT
    row_wid,
    table_name
FROM lkp_max_row_wid