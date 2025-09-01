{{
  config(
    materialized='table'
  )
}}

SELECT
  NISS_APRM_DETL_SK,
  NISS_CLASS_CD,
  REC_EXCPN_IND,
  REC_EXCP_DESC
FROM {{ ref('int_m_NU0C_NISS_AUTO_103_ATPRM_DTL_Upd_ClassCd') }};