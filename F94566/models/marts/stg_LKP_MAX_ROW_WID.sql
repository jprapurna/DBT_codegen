{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_CDM', 'LKP_MAX_ROW_WID') }}
)
SELECT
    *
FROM lkp_max_row_wid