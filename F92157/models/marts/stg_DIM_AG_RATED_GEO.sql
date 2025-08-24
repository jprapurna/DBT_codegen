{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "RATED_GEO_SK" AS rated_geo_sk, -- Surrogate key for rated geography
        "GRGNG_ZIP_5" AS grgng_zip_5, -- Garage ZIP code (5 digits)
        "FARMR_GEO_ST_SK" AS farmr_geo_st_sk -- Farmer geographic state surrogate key
    FROM {{ source('AGDM', 'DIM_AG_RATED_GEO') }}
)
SELECT
    rated_geo_sk,
    grgng_zip_5,
    farmr_geo_st_sk
FROM source_data