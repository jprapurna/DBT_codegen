{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        "CDH_GW_BUR" AS cdh_gw_bur -- Table does not exist or not authorized
    FROM {{ source('Snowflake_CDM', 'CDH_GW_BUR') }}
)
SELECT
    cdh_gw_bur
FROM cdh_gw_bur