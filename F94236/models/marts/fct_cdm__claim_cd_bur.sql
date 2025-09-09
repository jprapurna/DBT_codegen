{{
  config(materialized='table')
}}

SELECT 
  ROW_WID, 
  BUR, 
  NEW_BUR, 
  OLD_BUR
FROM {{ ref('int_cdh_gw__bur') }}

UNION ALL

SELECT 
  ROW_WID, 
  BUR, 
  NEW_BUR, 
  OLD_BUR
FROM {{ ref('int_cdm__claim_cd_bur_scd3') }}

UNION ALL

SELECT 
  ROW_WID, 
  BUR, 
  NEW_BUR, 
  OLD_BUR
FROM {{ ref('int_cdm__batch_ctrlid') }}

UNION ALL

SELECT 
  ROW_WID, 
  BUR, 
  NEW_BUR, 
  OLD_BUR
FROM {{ ref('int_cdm__max_row_wid') }}