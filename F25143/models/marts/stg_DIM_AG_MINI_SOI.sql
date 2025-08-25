{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "MINI_SOI_SK" AS mini_soi_sk, -- Surrogate key for mini SOI
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "VEH_TYP_CD" AS veh_typ_cd, -- Vehicle type code
        "VEH_TYP_DESC" AS veh_typ_desc, -- Vehicle type description
        "SOI_CTGY" AS soi_ctgy, -- SOI category
        "VEH_USE_CD" AS veh_use_cd -- Vehicle use code
    FROM {{ source('AGDM', 'DIM_AG_MINI_SOI') }}
)
SELECT
    mini_soi_sk,
    chk_sum_attr,
    veh_typ_cd,
    veh_typ_desc,
    soi_ctgy,
    veh_use_cd
FROM source_data