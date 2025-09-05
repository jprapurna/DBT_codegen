{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID,
    BUR,
    SOURCE_NAME
  FROM {{ ref('int_cdh_gw_bur') }}
),
lkp_w_claim_cd_bur_scd3 AS (
  SELECT 
    ROW_WID AS lkp_ROW_WID,
    INTEGRATION_ID AS lkp_INTEGRATION_ID,
    NEW_BUR AS lkp_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
  WHERE INTEGRATION_ID = source_data.INTEGRATION_ID
),
exp_flag AS (
  SELECT 
    CASE 
      WHEN lkp_ROW_WID IS NULL THEN 'I'
      WHEN MD5(BUR) = MD5(lkp_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
  FROM lkp_w_claim_cd_bur_scd3
)
SELECT *
FROM exp_flag