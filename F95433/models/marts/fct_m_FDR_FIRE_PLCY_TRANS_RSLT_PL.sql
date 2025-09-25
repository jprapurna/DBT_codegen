{{
  config(
    materialized='table'
  )
}}

SELECT * FROM {{ ref('int_m_FDR_FIRE_PLCY_TRANS_RSLT_PL') }}