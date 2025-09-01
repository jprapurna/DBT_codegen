{{
  config(materialized='table')
}}

SELECT
  NISS_APRM_DETL_SK,
  EXPS_VAL_ROLLED
FROM {{ ref('int_m_NU0C_NISS_AUTO_113_ATPRM_DTL_Upd_EXPS_VAL_ROLLED') }};