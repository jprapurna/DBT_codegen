{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        * -- No columns specified in source.yml
    FROM {{ source('DBA_COMMON_UTILS', 'CDH_GW_BUR') }}
)
SELECT
    *
FROM cdh_gw_bur