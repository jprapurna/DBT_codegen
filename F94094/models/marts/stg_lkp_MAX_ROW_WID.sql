{{ config(materialized='view') }}

WITH max_row_wid_data AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Maximum ROW_WID
        "TABLE_NAME" AS table_name    -- Target table name
    FROM {{ source('CDM', 'lkp_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM max_row_wid_data