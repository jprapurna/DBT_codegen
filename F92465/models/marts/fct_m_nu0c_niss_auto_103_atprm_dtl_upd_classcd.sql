{{ config(materialized='table') }}

SELECT
  *
FROM {{ ref('int_m_nu0c_niss_auto_103_atprm_dtl_upd_classcd')}}