{{ config(materialized='view') }}

SELECT
"NISS_APRM_FINAL_SK" AS niss_aprm_final_sk,
"CLNDR_YR" AS clndr_yr,
"CALL_YR" AS call_yr,
"NISS_CMPNY_CD" AS niss_cmpny_cd,
"ST_NM" AS st_nm,
"ST_CD" AS st_cd,
"ST_ABBR" AS st_abbr,
"NISS_ST_CD" AS niss_st_cd
FROM {{ source('staging', 'WRK_BIRP_NISS_APRM_FINAL') }}