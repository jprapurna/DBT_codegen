{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Maximum row identifier
"TABLE_NAME" AS table_name -- Name of the table
FROM {{ source('GENAI_POWER_BI', 'LKP_MAX_ROW_WID') }}