{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Maximum ROW_WID
        "TABLE_NAME" AS table_name    -- Table name
    FROM {{ source('CDM', 'lkp_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM source_data