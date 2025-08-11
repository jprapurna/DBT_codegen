{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row WID
"TABLE_NAME" AS table_name -- Table name
FROM {{ source('IICS', 'lkp_MAX_ROW_WID') }}