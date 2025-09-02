{{
  config(materialized='table')
}}

SELECT 
  *
FROM {{ ref('int_m_NU0C_NISS_AUTO_100_ATPRM_LND_Load') }};