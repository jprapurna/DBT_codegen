{{ config(materialized='view') }}

WITH max_row_wid AS (
    SELECT
        "ROW_WID" AS row_wid,       -- Row identifier
        "TABLE_NAME" AS table_name  -- Name of the table
    FROM {{ source('DBA_COMMON_UTILS', 'LKP_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM max_row_wid