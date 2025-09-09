{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        * -- No columns provided in source.yml
    FROM {{ source('CDH_GW_BUR', 'CDH_GW_BUR') }}
)
SELECT
    * -- No columns provided in source.yml
FROM cdh_gw_bur