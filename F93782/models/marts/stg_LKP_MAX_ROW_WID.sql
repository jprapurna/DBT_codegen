{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Row ID
        "TABLE_NAME" AS table_name    -- Name of the table
    FROM {{ source('CDM', 'LKP_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM source_data