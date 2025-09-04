{{
  config(materialized='table')
}}

SELECT 
  INTEGRATION_ID,
  BATCH_ID,
  SOURCE_NAME
FROM {{ ref('int_cdh_gw__bur') }}