{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdh_gwods', 'cdh_gw_bur') }}
),

lookup_data AS (
  SELECT 
    LKP_ROW_WID, 
    LKP_INTEGRATION_ID, 
    LKP_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

exp_flag AS (
  SELECT 
    INTEGRATION_ID,
    SOURCE_NAME,
    CASE 
      WHEN LKP_ROW_WID IS NULL THEN 'I'
      WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    'TARGET_TABLE' AS TGT_TABLE_NAME
  FROM source_data
  LEFT JOIN lookup_data ON source_data.INTEGRATION_ID = lookup_data.LKP_INTEGRATION_ID
),

final AS (
  SELECT *
  FROM exp_flag
)

SELECT * FROM final