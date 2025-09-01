{{
  config(
    materialized='table'
  )
}}

SELECT 
  CLNDR_YR,
  o_CLNDR_YR,
  NISS_CMPNY_CD,
  ST_NM,
  DET_PREM_AMT,
  DROP_PREM_AMT,
  FNL_PREM_AMT,
  BAL_DIFF,
  BAL_IND
FROM {{ ref('int_m_NU0C_NISS_AUTO_121_ATPRM_BalanceReports') }};