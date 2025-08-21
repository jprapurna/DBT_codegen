{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Maximum row ID
"TABLE_NAME" AS table_name -- Name of the table
FROM {{ source('CDH_GWODS', 'lkp_MAX_ROW_WID') }}