{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'SQ_CDH_GW_BUR') }}
)
SELECT
    *
FROM sq_cdh_gw_bur