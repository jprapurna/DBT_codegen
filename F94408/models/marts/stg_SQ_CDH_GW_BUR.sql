{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        *
    FROM {{ source('CDH_GWODS', 'SQ_CDH_GW_BUR') }}
)
SELECT
    *
FROM sq_cdh_gw_bur