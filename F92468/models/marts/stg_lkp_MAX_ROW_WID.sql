{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row width
"TABLE_NAME" AS table_name -- Table name
FROM {{ source('genai_power_bi', 'lkp_MAX_ROW_WID') }}