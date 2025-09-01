{{
  config(materialized='table')
}}

SELECT
  CR_BY_MAPNG_ID,
  DW_CR_TMSP,
  UPD_BY_MAPNG_ID,
  DW_UPD_TMSP,
  WRK_FLOW_RUN_ID
FROM { ref('int_m_nu0c_ta_niss_auto_atprm_lnd') }