{{ config(materialized='table') }}

SELECT
  *
FROM {{ ref('int_m_nu0c_niss_auto_114_atprm_dtl_upd_excpns_and_drops') }}