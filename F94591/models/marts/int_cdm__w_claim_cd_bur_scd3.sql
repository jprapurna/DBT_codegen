{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    ROW_WID AS LKP_ROW_WID,
    INTEGRATION_ID AS LKP_INTEGRATION_ID,
    NEW_BUR AS LKP_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
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
  FROM source_data
)

SELECT * FROM exp_flag