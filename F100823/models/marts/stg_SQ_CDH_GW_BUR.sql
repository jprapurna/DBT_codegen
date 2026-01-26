{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        "SQ_CDH_GW_BUR" AS sq_cdh_gw_bur -- Table identifier
    FROM {{ source('CDH_GWODS_CDM', 'SQ_CDH_GW_BUR') }}
)
SELECT
    sq_cdh_gw_bur
FROM sq_cdh_gw_bur