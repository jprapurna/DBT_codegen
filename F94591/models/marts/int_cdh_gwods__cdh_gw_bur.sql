{{ config(materialized='ephemeral') }}

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
    BUR AS BUR,
    SOURCE_NAME AS SOURCE_NAME
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
    *,
    CASE 
      WHEN LKP_ROW_WID IS NULL THEN 'I'
      WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag,
    SYSDATE AS CDM_INSERT_DT,
    SYSDATE AS CDM_UPDATE_DT,
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
  FROM lkp_w_claim_cd_bur_scd3
),

rtr_clm_insert_upd AS (
  SELECT
    *,
    CASE WHEN o_Flag = 'I' THEN 'INSERT'
         WHEN o_Flag = 'U' THEN 'UPDATE'
    END AS ROUTE
  FROM exp_flag
)

SELECT * FROM rtr_clm_insert_upd