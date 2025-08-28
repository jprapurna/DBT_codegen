{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Maximum row ID
        "TABLE_NAME" AS table_name    -- Name of the target table
    FROM {{ source('genai_power_bi', 'lkp_max_row_wid') }}
)
SELECT
    row_wid,
    table_name
FROM source_data