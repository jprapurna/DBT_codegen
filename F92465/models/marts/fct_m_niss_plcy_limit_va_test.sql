{{
  config(materialized='table')
}}

SELECT
  *
FROM {{ ref('int_m_niss_plcy_limit_va_test') }}