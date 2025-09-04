{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        * -- No columns specified in source.yml
    FROM {{ source('SQ_CDH_GW_BUR', 'SQ_CDH_GW_BUR') }}
)
SELECT
    * -- No columns specified in source.yml
FROM sq_cdh_gw_bur