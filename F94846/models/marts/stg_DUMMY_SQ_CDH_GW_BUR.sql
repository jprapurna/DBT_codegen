{{ config(materialized='view') }}

WITH dummy_sq_cdh_gw_bur AS (
    SELECT
        "DUMMY_SQ_CDH_GW_BUR" AS dummy_sq_cdh_gw_bur -- Table identifier
    FROM {{ source('DUMMY_SQ_CDH_GW_BUR', 'DUMMY_SQ_CDH_GW_BUR') }}
)
SELECT
    dummy_sq_cdh_gw_bur
FROM dummy_sq_cdh_gw_bur