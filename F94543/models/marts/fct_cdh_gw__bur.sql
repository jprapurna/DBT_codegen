{{ config(materialized='table') }}

SELECT 
  POLICY_STATE,
  BUR,
  SOURCE_NAME,
  INTEGRATION_ID
FROM {{ ref('int_cdh_gw__bur') }}