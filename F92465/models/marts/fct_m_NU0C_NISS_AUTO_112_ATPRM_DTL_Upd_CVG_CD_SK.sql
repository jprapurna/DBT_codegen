{{
  config(
    materialized='table'
  )
}}

SELECT
  *
FROM {{ ref('int_m_NU0C_NISS_AUTO_112_ATPRM_DTL_Upd_CVG_CD_SK') }}