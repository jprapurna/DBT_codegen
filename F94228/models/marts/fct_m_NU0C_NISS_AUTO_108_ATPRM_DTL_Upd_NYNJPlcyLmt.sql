{{
  config(materialized='table')
}}

SELECT
  NISS_APRM_DETL_SK,
  NISS_PLCY_LMT_CD,
  NISS_DEDUC_CD
FROM {{ ref('int_m_NU0C_NISS_AUTO_108_ATPRM_DTL_Upd_NYNJPlcyLmt') }};