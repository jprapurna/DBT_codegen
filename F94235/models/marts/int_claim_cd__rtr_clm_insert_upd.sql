{{ config(materialized='ephemeral') }}

WITH routed_data AS (
  SELECT 
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT,
    TGT_TABLE_NAME
  FROM {{ ref('int_claim_cd__exp_flag') }}
  WHERE o_Flag IN ('I', 'U')
)
SELECT * FROM routed_data