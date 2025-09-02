{{ config(materialized='table') }}

SELECT
  REF.NISS_TERR_CD AS niss_terr_cd,
  REF.NISS_ST_CD AS niss_st_cd,
  REF.ST_ABBRV AS st_abbrv,
  REF.ZIP_CD AS zip_cd
FROM {{ source('birp', 'rbi_ref_auto_terr') }} REF
WHERE REF.END_EFF_DT = '2999-12-31'
  AND REF.PP_COMMRCL_CD IN ('BOTH', 'PP')
ORDER BY REF.NISS_ST_CD, REF.ST_ABBRV, REF.ZIP_CD