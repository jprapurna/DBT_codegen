{{ config(materialized='table') }}

SELECT 
  *
FROM {{ ref('int_cdm__batch_ctrlid') }}