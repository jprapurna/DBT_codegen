{{
  config(materialized='table')
}}

SELECT
  REG_PER_YR,
  FISC_PER_YR,
  NAIC_CMPY_CD,
  ST_NM,
  ST_CD,
  ACCTNG_LOB,
  CVG_TYP_CD,
  CVG_AMT,
  BI_LMT,
  NISS_TERR_CD
FROM {{ ref('int_m_nu0c_niss_auto_100_atprm_lnd_load') }}