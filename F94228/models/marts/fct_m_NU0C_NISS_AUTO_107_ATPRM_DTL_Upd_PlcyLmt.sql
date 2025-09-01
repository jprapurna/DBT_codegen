{{
  config(
    materialized='table'
  )
}}

SELECT 
  NISS_APRM_DETL_SK,
  NISS_PLCY_LMT_CD
FROM {{ ref('int_m_NU0C_NISS_AUTO_107_ATPRM_DTL_Upd_PlcyLmt') }};