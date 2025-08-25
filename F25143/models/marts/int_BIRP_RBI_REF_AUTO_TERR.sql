{{ config(materialized='table') }}
-- Source table BIRP.RBI_REF_AUTO_TERR used for lookup with SQL override applied.
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
FROM {{ source('BIRP', 'RBI_REF_AUTO_TERR') }} REF
WHERE REF.END_EFF_DT = '2999-12-31'
ORDER BY NISS_ST_CD, ST_ABBRV, ZIP_CD, PP_COMMRCL_CD
-- Keep this as last line to disable Informatica default orderby clause.