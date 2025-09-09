{{ config(materialized='view') }}

WITH lkp_max_row_wid AS (
    SELECT
        column_name_1 AS column_name_1, -- Description for column_name_1
        column_name_2 AS column_name_2  -- Description for column_name_2
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'LKP_MAX_ROW_WID') }}
)
SELECT
    column_name_1,
    column_name_2
FROM lkp_max_row_wid