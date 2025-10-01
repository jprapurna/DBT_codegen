{{ config(materialized='ephemeral') }}

WITH cdh_gw_bur_data AS (
  SELECT * 
  FROM {{ ref('int_cdh_gw__bur') }}
),

batch_id_data AS (
  SELECT * 
  FROM {{ ref('int_cdm__batch_id') }}
),

lookup_data AS (
  SELECT 
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    LKP_NEW_BUR
  FROM {{ source('cdm', 'lkp_w_claim_cd_bur_scd3') }}
),

joined_data AS (
  SELECT
    cdh_gw_bur_data.*,
    batch_id_data.hashed_batch_id,
    lookup_data.LKP_NEW_BUR
  FROM cdh_gw_bur_data
  LEFT JOIN batch_id_data ON cdh_gw_bur_data.BUR = batch_id_data.BUR
  LEFT JOIN lookup_data ON cdh_gw_bur_data.POLICY_STATE = lookup_data.LKP_INTEGRATION_ID
),

exp_flag AS (
  SELECT
    *,
    CASE 
      WHEN LKP_NEW_BUR IS NOT NULL THEN 'UPDATE'
      ELSE 'INSERT'
    END AS operation_flag
  FROM joined_data
)

SELECT * FROM exp_flag