{{ config(materialized='table') }}
SELECT
    NISS_TERR_CD,
    NISS_ST_CD,
    ST_ABBRV,
    ZIP_CD
FROM {{ ref('int_auto_territory_mapping') }}