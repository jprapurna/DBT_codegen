{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Maximum row WID
"TABLE_NAME" AS table_name -- Table name
FROM {{ source('genai_power_bi', 'lkp_MAX_ROW_WID') }}