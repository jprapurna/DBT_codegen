{{
  config(
    materialized='table'
  )
}}

SELECT
  NISS_APRM_DETL_SK,
  CVG_CD_ATTR_SK
FROM {{ ref('int_m_NU0C_NISS_AUTO_112_ATPRM_DTL_Upd_CVG_CD_SK') }};