{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        row_wid AS row_wid,         -- Row identifier
        table_name AS table_name    -- Name of the table
    FROM {{ source('DBA_COMMON_UTILS', 'LKP_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM lkp_max_row_wid