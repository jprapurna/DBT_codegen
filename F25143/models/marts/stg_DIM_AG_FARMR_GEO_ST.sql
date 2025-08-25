{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "FARMR_GEO_ST_SK" AS farmr_geo_st_sk, -- Surrogate key for farmer geographic state
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "ST_CD" AS st_cd, -- State code
        "ST_NM" AS st_nm, -- State name
        "ZONE" AS zone, -- Zone information
        "CORE_29_IND" AS core_29_ind -- Core 29 indicator
    FROM {{ source('AGDM', 'DIM_AG_FARMR_GEO_ST') }}
)
SELECT
    farmr_geo_st_sk,
    chk_sum_attr,
    st_cd,
    st_nm,
    zone,
    core_29_ind
FROM source_data