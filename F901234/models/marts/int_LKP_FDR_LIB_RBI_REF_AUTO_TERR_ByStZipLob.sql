-- Purpose: Lookup transformation to fetch territory details
WITH auto_territory AS (
  SELECT 
    NISS_TERR_CD, 
    NISS_ST_CD, 
    ST_ABBRV, 
    ZIP_CD 
  FROM {{ source('BIRP', 'RBI_REF_AUTO_TERR') }}
  WHERE END_EFF_DT = '2999-12-31' 
    AND PP_COMMRCL_CD IN ('BOTH','PP')
)
SELECT 
  NISS_TERR_CD, 
  NISS_ST_CD, 
  ST_ABBRV, 
  ZIP_CD 
FROM auto_territory