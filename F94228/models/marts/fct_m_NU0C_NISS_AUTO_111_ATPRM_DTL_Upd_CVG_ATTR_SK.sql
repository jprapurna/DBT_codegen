{{
  config(materialized='table')
}}

SELECT
  NISS_APRM_DETL_SK,
  CVG_ATTR_SK,
  CVG_ATTR_CHCKSUM
FROM {{ ref('int_m_NU0C_NISS_AUTO_111_ATPRM_DTL_Upd_CVG_ATTR_SK') }};