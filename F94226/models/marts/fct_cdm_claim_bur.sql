{{ config(materialized='table') }}

SELECT 
  *
FROM {{ ref('int_cdm_insert_update') }}