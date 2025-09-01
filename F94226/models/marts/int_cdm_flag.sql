{{ config(materialized='ephemeral') }}

WITH lookup_claim_cd_bur AS (
  SELECT 
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    LKP_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

exp_flag AS (
  SELECT 
    CASE 
      WHEN LKP_ROW_WID IS NULL THEN 'I'
      WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    'TARGET_TABLE_NAME' AS TGT_TABLE_NAME
  FROM lookup_claim_cd_bur
)

SELECT *
FROM exp_flag