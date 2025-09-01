{{ config(materialized='ephemeral') }}

WITH exp_bur_data AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID,
    BUR,
    SOURCE_NAME
  FROM {{ ref('int_claim_cd__sq_cdh_gw_bur') }}
)
SELECT * FROM exp_bur_data