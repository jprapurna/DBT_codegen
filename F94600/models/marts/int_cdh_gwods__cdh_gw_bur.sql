{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    policy_state,
    bur,
    'GWCDH' AS source_name
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

exp_bur AS (
  SELECT
    policy_state AS integration_id,
    bur AS bur,
    source_name AS source_name
  FROM source_data
),

lkp_w_claim_cd_bur_scd3 AS (
  SELECT 
    row_wid AS lkp_row_wid,
    integration_id AS lkp_integration_id,
    new_bur AS lkp_new_bur
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
  WHERE integration_id = exp_bur.integration_id
),

exp_flag AS (
  SELECT
    *,
    CASE 
      WHEN lkp_row_wid IS NULL THEN 'I'
      WHEN MD5(bur) = MD5(lkp_new_bur) THEN 'NC'
      ELSE 'U'
    END AS o_flag,
    CURRENT_TIMESTAMP AS cdm_insert_dt,
    CURRENT_TIMESTAMP AS cdm_update_dt,
    'target_table_name' AS tgt_table_name
  FROM lkp_w_claim_cd_bur_scd3
),

rtr_clm_insert_upd AS (
  SELECT
    *,
    CASE 
      WHEN o_flag = 'I' THEN 'INSERT'
      WHEN o_flag = 'U' THEN 'UPDATE'
      ELSE 'REJECT'
    END AS operation_type
  FROM exp_flag
)

SELECT * FROM rtr_clm_insert_upd