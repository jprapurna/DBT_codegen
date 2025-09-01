{{ config(materialized='table') }}

SELECT 
  v_CNT, 
  NISS_APRM_DETL_SK, 
  CALL_YR, 
  o_AUTO_USE_CD, 
  o_NISS_TERR_CD
FROM {{ ref('int_m_nu0c_niss_auto_102_atprm_dtl_load') }}