{{
  config(
    materialized='table'
  )
}}

SELECT
  *
FROM {{ ref('int_m_nu0c_niss_auto_atprm_dtl_postsql_upd_dummy') }}