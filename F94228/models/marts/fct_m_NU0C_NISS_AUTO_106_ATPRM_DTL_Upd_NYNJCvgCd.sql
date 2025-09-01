{{
  config(materialized='table')
}}

SELECT
  NISS_APRM_DETL_SK,
  NISS_CVG_CD,
  NISS_SSL_LIAB_CD,
  NISS_LIAB_OR_NO_FAULT_CD,
  REC_EXCPN_IND
FROM {{ ref('int_m_NU0C_NISS_AUTO_106_ATPRM_DTL_Upd_NYNJCvgCd') }};