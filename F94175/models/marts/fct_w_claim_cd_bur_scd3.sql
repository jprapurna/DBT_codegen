{{ config(materialized='table') }}
SELECT 
  BUR,
  LKP_NEW_BUR
FROM {{ ref('int_exp_flag') }}