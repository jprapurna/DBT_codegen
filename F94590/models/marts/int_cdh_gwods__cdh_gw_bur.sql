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
    BUR AS BUR,
    SOURCE_NAME AS SOURCE_NAME
  FROM source_data
),

lkp_w_claim_cd_bur_scd3 AS (
  SELECT 
    *,
    CASE 
      WHEN {{ isnull('LKP_ROW_WID', 'NULL') }} THEN 'I'
      WHEN {{ md5('BUR') }} = {{ md5('LKP_NEW_BUR') }} THEN 'NC'
      ELSE 'U'
    END AS o_Flag
  FROM exp_bur
  LEFT JOIN (
    SELECT 
      ROW_WID AS LKP_ROW_WID,
      INTEGRATION_ID AS LKP_INTEGRATION_ID,
      NEW_BUR AS LKP_NEW_BUR
    FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
  ) AS lookup
  ON lookup.LKP_INTEGRATION_ID = exp_bur.INTEGRATION_ID
),

exp_flag AS (
  SELECT 
    *,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    'w_claim_cd_bur_scd3' AS TGT_TABLE_NAME
  FROM lkp_w_claim_cd_bur_scd3
),

rtr_clm_insert_upd AS (
  SELECT 
    *
  FROM exp_flag
  WHERE o_Flag IN ('I', 'U')
)

SELECT * FROM rtr_clm_insert_upd