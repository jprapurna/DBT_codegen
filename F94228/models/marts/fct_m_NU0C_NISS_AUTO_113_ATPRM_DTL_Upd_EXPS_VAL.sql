{{
  config(materialized='table')
}}

SELECT
  NISS_APRM_DETL_SK,
  CVG_EXPS_VAL,
  PLCY_CNTRCT_NUM,
  UNIT_NUM,
  EFF_DT,
  EXP_VAL_ROLLED
FROM {{ ref('int_m_NU0C_NISS_AUTO_113_ATPRM_DTL_Upd_EXPS_VAL') }};