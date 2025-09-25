{{ config(materialized='ephemeral') }}

WITH exp_bur_data AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID, 
    BUR, 
    SOURCE_NAME 
  FROM {{ ref('int_claim_cd_bur__source') }}
)

SELECT * FROM exp_bur_data