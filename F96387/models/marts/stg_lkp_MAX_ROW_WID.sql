{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Maximum Row WID
"TABLE_NAME" AS table_name -- Name of the target table
FROM {{ source('IICS', 'lkp_MAX_ROW_WID') }}