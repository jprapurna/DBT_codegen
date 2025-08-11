{{ config(materialized='view') }}

SELECT
"NISS_APRM_FINAL_SK" AS niss_aprm_final_sk, -- Unique identifier for the final record.
"CLNDR_YR" AS clndr_yr, -- Calendar year of the record.
"CALL_YR" AS call_yr, -- Year of the call.
"NISS_CMPNY_CD" AS niss_cmpny_cd, -- NISS company code.
"ST_NM" AS st_nm, -- State name.
"ST_CD" AS st_cd, -- State code.
"ST_ABBR" AS st_abbr, -- State abbreviation.
"NISS_ST_CD" AS niss_st_cd -- NISS state code.
FROM {{ source('WRK_BIRP_NISS_APRM_FINAL', 'WRK_BIRP_NISS_APRM_FINAL') }}