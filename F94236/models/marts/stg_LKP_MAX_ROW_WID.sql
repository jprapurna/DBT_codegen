{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        "ROW_WID" AS row_wid,         -- Maximum row identifier
        "TABLE_NAME" AS table_name   -- Name of the table associated with the row identifier
    FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM lkp_max_row_wid