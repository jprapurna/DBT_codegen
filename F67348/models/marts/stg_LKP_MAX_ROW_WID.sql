{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Maximum row width
        "TABLE_NAME" AS table_name    -- Name of the table
    FROM {{ source('MAX_ROW_WID', 'LKP_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM source_data