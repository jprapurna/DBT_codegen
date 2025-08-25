{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "RATED_GEO_SK" AS rated_geo_sk, -- Surrogate key for rated geography
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "GRGNG_ZIP_3" AS grgng_zip_3, -- Garage ZIP code (3 digits)
        "GRGNG_ZIP_5" AS grgng_zip_5, -- Garage ZIP code (5 digits)
        "GRGNG_ZIP_PLUS4" AS grgng_zip_plus4 -- Garage ZIP code (plus 4 digits)
    FROM {{ source('AGDM', 'DIM_AG_RATED_GEO') }}
)
SELECT
    rated_geo_sk,
    chk_sum_attr,
    grgng_zip_3,
    grgng_zip_5,
    grgng_zip_plus4
FROM source_data