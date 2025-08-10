-- Purpose: Fetch territory details based on state, abbreviation, ZIP code, and commercial code.

WITH territory_lookup AS (
  SELECT
    NISS_ST_CD,
    ST_ABBRV,
    ZIP_CD,
    PP_COMMRCL_CD
  FROM {{ source('BIRP', 'RBI_REF_AUTO_TERR') }}
  WHERE NISS_ST_CD = {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }}.i_NISS_ST_CD
    AND ST_ABBRV = {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }}.i_ST_ABBRV
    AND ZIP_CD = {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }}.i_ZIP_CD
    AND PP_COMMRCL_CD = {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }}.i_PP_COMMRCL_CD
)

SELECT
  NISS_ST_CD,
  ST_ABBRV,
  ZIP_CD,
  PP_COMMRCL_CD
FROM territory_lookup