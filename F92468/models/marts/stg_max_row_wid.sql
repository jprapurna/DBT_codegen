{{ config(materialized='view') }}

SELECT
"row_wid" AS row_wid, -- Maximum row identifier
"table_name" AS table_name -- Table name
FROM {{ source('genai_power_bi', 'max_row_wid') }}