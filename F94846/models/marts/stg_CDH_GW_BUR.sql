{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        "CDH_GW_BUR" AS cdh_gw_bur -- Table identifier
    FROM {{ source('CDH_GW_BUR', 'CDH_GW_BUR') }}
)
SELECT
    cdh_gw_bur
FROM cdh_gw_bur