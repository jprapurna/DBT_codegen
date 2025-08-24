{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "FARMR_GEO_ST_SK" AS farmr_geo_st_sk, -- Surrogate key for farmer geographic state
        "ST_CD" AS st_cd, -- State code
        "ST_NM" AS st_nm -- State name
    FROM {{ source('AGDM', 'DIM_AG_FARMR_GEO_ST') }}
)
SELECT
    farmr_geo_st_sk,
    st_cd,
    st_nm
FROM source_data