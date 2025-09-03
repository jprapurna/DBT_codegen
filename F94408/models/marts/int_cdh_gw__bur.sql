{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * 
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
    INTEGRATION_ID,
    BUR,
    SOURCE_NAME
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

exp_flag AS (
  SELECT 
    CASE 
      WHEN INTEGRATION_ID IS NULL THEN 'I'
      ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    'TGT_TABLE_NAME' AS TGT_TABLE_NAME
  FROM exp_bur
)

SELECT *
FROM exp_flag