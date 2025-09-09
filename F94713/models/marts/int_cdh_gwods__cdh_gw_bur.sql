{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    'GWCDH' AS SOURCE_NAME
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

exp_bur AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID, 
    BUR, 
    SOURCE_NAME
  FROM source_data
),

lkp_w_claim_cd_bur_scd3 AS (
  SELECT 
    ROW_WID AS LKP_ROW_WID, 
    INTEGRATION_ID AS LKP_INTEGRATION_ID, 
    NEW_BUR AS LKP_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
  WHERE INTEGRATION_ID = exp_bur.INTEGRATION_ID
),

exp_flag AS (
  SELECT 
    {{ macro_flag_logic('lkp_w_claim_cd_bur_scd3.LKP_ROW_WID', 'exp_bur.BUR', 'lkp_w_claim_cd_bur_scd3.LKP_NEW_BUR') }} AS o_Flag,
    SYSDATE AS CDM_INSERT_DT,
    SYSDATE AS CDM_UPDATE_DT,
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
  FROM exp_bur
),

rtr_clm_insert_upd AS (
  SELECT *
  FROM exp_flag
  WHERE o_Flag IN ('I', 'U')
)

SELECT *
FROM rtr_clm_insert_upd