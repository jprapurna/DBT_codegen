{{ config(materialized='table') }}

SELECT 
  *
FROM {{ ref('int_cdm__max_row_wid') }}