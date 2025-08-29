{{ config(materialized='view') }}

WITH cdm_row_wid_max AS (
    SELECT
        "ROW_WID" AS row_wid,           -- Maximum row identifier
        "TABLE_NAME" AS table_name      -- Name of the table
    FROM {{ source('CDM_ROW_WID_MAX', 'CDM_ROW_WID_MAX') }}
)
SELECT
    row_wid,
    table_name
FROM cdm_row_wid_max