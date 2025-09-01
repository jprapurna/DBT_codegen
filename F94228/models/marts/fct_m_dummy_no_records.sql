{{
  config(materialized='table')
}}

SELECT *
FROM {{ ref('int_m_dummy_no_records') }};