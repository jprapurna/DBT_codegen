{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        column_name_1 AS column_name_1, -- Description for column_name_1
        column_name_2 AS column_name_2  -- Description for column_name_2
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'SQ_CDH_GW_BUR') }}
)
SELECT
    column_name_1,
    column_name_2
FROM sq_cdh_gw_bur