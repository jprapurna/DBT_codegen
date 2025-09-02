{{
  config(
    materialized='table'
  )
}}

SELECT
  NISS_APRM_DETL_SK,
  CVG_ATTR_CHCKSUM
FROM {{ ref('int_m_nu0c_niss_auto_111a_atprm_dtl_upd_cvgattrchksum') }}