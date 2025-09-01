{{ config(materialized='view') }}

SELECT
    "ROW_WID" AS row_wid,       -- Row width identifier
    "TABLE_NAME" AS table_name  -- Name of the table
FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_MAX_ROW_WID') }}