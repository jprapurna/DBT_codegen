{{ config(materialized='view') }}

WITH row_wid_data AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'ROW_WID') }}
)
SELECT
    *
FROM row_wid_data