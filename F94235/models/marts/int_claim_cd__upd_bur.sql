{{ config(materialized='ephemeral') }}

WITH update_data AS (
  SELECT 
    DD_UPDATE AS Update_Strategy_Expression_78066,
    in_INTEGRATION_ID,
    LKP_INTEGRATION_ID,
    o_Flag,
    BATCH_ID
  FROM {{ ref('int_claim_cd__rtr_clm_insert_upd') }}
)
SELECT * FROM update_data