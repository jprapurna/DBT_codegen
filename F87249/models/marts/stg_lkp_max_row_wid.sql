{{ config(materialized='view') }}

WITH max_row_data AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Maximum row identifier
        "TABLE_NAME" AS table_name    -- Name of the table
    FROM {{ source('CDM', 'LKP_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM max_row_data