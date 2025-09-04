{{
  config(materialized='table')
}}

SELECT 
  ROW_WID,
  TABLE_NAME
FROM {{ ref('int_cdm__row_wid') }}