{{
  config(materialized='table')
}}

SELECT * FROM {{ ref('int_m_NU0C_NISS_AUTO_119_ATPRM_CreateReports') }};