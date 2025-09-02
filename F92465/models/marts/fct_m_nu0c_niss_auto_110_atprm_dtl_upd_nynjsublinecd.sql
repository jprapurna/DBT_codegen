{{ config(materialized='table') }}

SELECT 
  *
FROM {{ ref('int_m_nu0c_niss_auto_110_atprm_dtl_upd_nynjsublinecd') }}