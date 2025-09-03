{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        ROW_WID AS row_wid,         -- Row ID
        TABLE_NAME AS table_name    -- Name of the table
    FROM {{ source('Snowflake_CDM', 'LKP_MAX_ROW_WID') }}
)
SELECT
    row_wid,
    table_name
FROM lkp_max_row_wid