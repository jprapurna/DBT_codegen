-- Purpose: Lookup transformation to fetch territory details based on state, abbreviation, ZIP code, and commercial code.

WITH lookup AS (
  SELECT
    NISS_ST_CD,
    ST_ABBRV,
    ZIP_CD,
    PP_COMMRCL_CD
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE NISS_ST_CD = i_NISS_ST_CD
    AND ST_ABBRV = i_ST_ABBRV
    AND ZIP_CD = i_ZIP_CD
    AND PP_COMMRCL_CD = i_PP_COMMRCL_CD
)

SELECT
  i_NISS_ST_CD AS NISS_ST_CD,
  i_ST_ABBRV AS ST_ABBRV,
  i_ZIP_CD AS ZIP_CD,
  i_PP_COMMRCL_CD AS PP_COMMRCL_CD
FROM lookup