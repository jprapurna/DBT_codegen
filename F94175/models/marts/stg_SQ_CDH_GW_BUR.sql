{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "DUMMY_SQ_CDH_GW_BUR" AS dummy_sq_cdh_gw_bur -- Error: Table does not exist or not authorized
    FROM {{ source('CDH_GWODS', 'SQ_CDH_GW_BUR') }}
)
SELECT
    dummy_sq_cdh_gw_bur
FROM source_data