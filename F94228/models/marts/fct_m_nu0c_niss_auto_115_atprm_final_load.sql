{{ config(materialized='table') }}

SELECT *
FROM {{ ref('int_m_nu0c_niss_auto_115_atprm_final_load') }}