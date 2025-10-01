{{ config(materialized='table') }}

SELECT 
  *
FROM {{ ref('int_cdm__row_wid_lkp_max_row_wid') }}