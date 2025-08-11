-- Purpose: Lookup transformation to fetch territory details based on state, abbreviation, and zip code using SQL override
WITH lookup_auto_terr AS (
  SELECT 
    NISS_TERR_CD
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT 
  i_NISS_ST_CD,
  i_ST_ABBRV,
  i_ZIP_CD,
  NISS_TERR_CD
FROM lookup_auto_terr
WHERE NISS_ST_CD = i_NISS_ST_CD AND ST_ABBRV = i_ST_ABBRV AND ZIP_CD = i_ZIP_CD