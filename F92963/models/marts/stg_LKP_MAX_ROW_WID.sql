{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row identifier
"TABLE_NAME" AS table_name -- Name of the table
FROM {{ source('genai_power_bi', 'LKP_MAX_ROW_WID') }}