{{
  config(materialized='incremental', unique_key='POLICY_STATE, BUR')
}}

WITH source_data AS (
  SELECT POLICY_STATE, BUR, 'GWCDH' AS SOURCE_NAME
  FROM {{ source('schema_cdh_gwods', 'cdh_gw_bur') }}
),

exp_bur AS (
  SELECT
    POLICY_STATE,
    BUR,
    SOURCE_NAME,
    POLICY_STATE AS INTEGRATION_ID
  FROM source_data
),

lookup_data AS (
  SELECT
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    LKP_NEW_BUR
  FROM {{ source('schema_cdm', 'w_claim_cd_bur_scd3') }}
  WHERE INTEGRATION_ID = POLICY_STATE AND BUR = BUR
),

exp_flag AS (
  SELECT
    *,
    CASE 
      WHEN ISNULL(LKP_ROW_WID) THEN 'I'
      WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag
  FROM exp_bur
  LEFT JOIN lookup_data ON exp_bur.INTEGRATION_ID = lookup_data.LKP_INTEGRATION_ID
),

rtr_clm_insert_upd AS (
  SELECT *
  FROM exp_flag
  WHERE o_Flag IN ('I', 'U')
)

SELECT *
FROM rtr_clm_insert_upd