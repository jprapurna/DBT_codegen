{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Maximum row ID
"TABLE_NAME" AS table_name -- Table name
FROM {{ source('CDM', 'lkp_MAX_ROW_WID') }}