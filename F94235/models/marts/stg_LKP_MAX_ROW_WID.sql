{{ config(materialized='view') }}

SELECT
    ROW_WID AS row_wid,         -- Row WID column
    TABLE_NAME AS table_name    -- Table name column
FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_MAX_ROW_WID') }}