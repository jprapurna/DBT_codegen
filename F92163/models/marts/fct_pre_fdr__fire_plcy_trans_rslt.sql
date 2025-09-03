{{
  config(
    materialized='table'
  )
}}

SELECT *
FROM {{ ref('int_pre_fdr__fire_plcy_trans_rslt') }}