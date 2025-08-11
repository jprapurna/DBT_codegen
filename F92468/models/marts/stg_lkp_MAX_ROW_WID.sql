{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row ID
"TABLE_NAME" AS table_name -- Name of the table
FROM {{ source('CLAIM_DATA', 'lkp_MAX_ROW_WID') }}