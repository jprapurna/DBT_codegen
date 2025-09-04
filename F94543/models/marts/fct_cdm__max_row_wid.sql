{{ config(materialized='table') }}

SELECT 
  ROW_WID,
  TABLE_NAME
FROM {{ ref('int_cdm__max_row_wid') }}