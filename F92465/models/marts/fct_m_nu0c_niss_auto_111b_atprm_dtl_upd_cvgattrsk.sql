{{
  config(materialized='table')
}}

SELECT 
  NISS_APRM_DETL_SK,
  CVG_ATTR_SK
FROM {{ ref('int_m_nu0c_niss_auto_111b_atprm_dtl_upd_cvgattrsk') }}