{{ config(materialized='table') }}

SELECT 
  BATCH_ID,
  SOURCE_NAME
FROM {{ ref('int_cdm__batch_ctrlid') }}