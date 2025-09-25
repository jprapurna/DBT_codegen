{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_V2', 'CDH_GW_BUR') }}
)
SELECT
    *
FROM cdh_gw_bur