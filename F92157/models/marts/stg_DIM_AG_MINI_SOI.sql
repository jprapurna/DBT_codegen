{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "MINI_SOI_SK" AS mini_soi_sk, -- Surrogate key for mini SOI
        "VEH_TYP_CD" AS veh_typ_cd, -- Vehicle type code
        "VEH_TYP_DESC" AS veh_typ_desc -- Vehicle type description
    FROM {{ source('AGDM', 'DIM_AG_MINI_SOI') }}
)
SELECT
    mini_soi_sk,
    veh_typ_cd,
    veh_typ_desc
FROM source_data
