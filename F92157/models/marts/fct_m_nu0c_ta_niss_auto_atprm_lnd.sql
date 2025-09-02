{{
  config(
    materialized='table'
  )
}}

SELECT
  *
FROM {{ ref('int_m_nu0c_ta_niss_auto_atprm_lnd') }}