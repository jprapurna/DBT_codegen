-- Purpose: Lookup transformation to fetch territory details based on state, abbreviation, zip code, and commercial code using SQL override

WITH lookup_data AS (
  SELECT 
    REF.REF_AUTO_TERR_SK,
    REF.END_EFF_DT,
    REF.CHCKSUM,
    REF.CR_BY_MAPNG_ID,
    REF.DW_CR_TMSP,
    REF.UPD_BY_MAPNG_ID,
    REF.DW_UPD_TMSP,
    REF.WRK_FLOW_RUN_ID,
    REF.NISS_TERR_CD,
    REF.CNTY_NM,
    REF.CITY_NM,
    REF.SRC_EFF_DT,
    REF.SRC_OBSLT_DT,
    REF.NISS_ST_CD,
    REF.ST_ABBRV,
    REF.ZIP_CD,
    REF.PP_COMMRCL_CD
  FROM 
    {{ source('BIRP', 'RBI_REF_AUTO_TERR') }} REF
  WHERE 
    REF.END_EFF_DT = '2999-12-31'
  ORDER BY 
    NISS_ST_CD, ST_ABBRV, ZIP_CD, PP_COMMRCL_CD
)

SELECT 
  i_NISS_ST_CD,
  i_ST_ABBRV,
  i_ZIP_CD,
  i_PP_COMMRCL_CD,
  lookup_data.REF_AUTO_TERR_SK,
  lookup_data.END_EFF_DT,
  lookup_data.CHCKSUM,
  lookup_data.CR_BY_MAPNG_ID,
  lookup_data.DW_CR_TMSP,
  lookup_data.UPD_BY_MAPNG_ID,
  lookup_data.DW_UPD_TMSP,
  lookup_data.WRK_FLOW_RUN_ID,
  lookup_data.NISS_TERR_CD,
  lookup_data.CNTY_NM,
  lookup_data.CITY_NM,
  lookup_data.SRC_EFF_DT,
  lookup_data.SRC_OBSLT_DT
FROM 
  lookup_data
WHERE 
  lookup_data.NISS_ST_CD = i_NISS_ST_CD
  AND lookup_data.ST_ABBRV = i_ST_ABBRV
  AND lookup_data.ZIP_CD = i_ZIP_CD
  AND lookup_data.PP_COMMRCL_CD = i_PP_COMMRCL_CD