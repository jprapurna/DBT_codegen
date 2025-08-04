{{ config(materialized='view') }}

SELECT
ROW_WID AS row_wid, -- Row wide identifier
TABLE_NAME AS table_name -- Name of the table
FROM {{ source('genai_power_bi', 'lkp_MAX_ROW_WID') }}