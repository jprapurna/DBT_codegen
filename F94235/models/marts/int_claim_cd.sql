{{
  config(materialized='ephemeral')
}}

WITH sq_cdh_gw_bur AS (
  SELECT 
    POLICY_STATE,
    BUR,
    '{{ macro_source_name_gwcdm() }}' AS SOURCE_NAME
  FROM {{ source('GENAI_POWER_BI_CDM', 'CDH_GW_BUR') }}
),

exp_bur AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID,
    BUR,
    SOURCE_NAME
  FROM sq_cdh_gw_bur
),

lkp_w_claim_cd_bur_scd3 AS (
  SELECT 
    ROW_WID AS LKP_ROW_WID,
    INTEGRATION_ID AS LKP_INTEGRATION_ID,
    NEW_BUR AS LKP_NEW_BUR
  FROM {{ source('GENAI_POWER_BI_CDM', 'W_CLAIM_CD_BUR_SCD3') }}
  WHERE INTEGRATION_ID = exp_bur.INTEGRATION_ID
),

exp_flag AS (
  SELECT 
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
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT,
    TGT_TABLE_NAME,
    CASE 
      WHEN o_Flag = 'I' THEN 'INSERT'
      WHEN o_Flag = 'U' THEN 'UPDATE'
    END AS ROUTE
  FROM exp_flag
),

upd_bur AS (
  SELECT 
    CASE 
      WHEN ROUTE = 'UPDATE' THEN 'DD_UPDATE'
    END AS Update_Strategy_Expression_78066,
    o_Flag AS o_Flag1,
    CDM_INSERT_DT,
    CDM_UPDATE_DT
  FROM rtr_clm_insert_upd
),

mplt_cdm_row_wid AS (
  SELECT 
    {{ mplt_cdm_row_wid('W_CLAIM_CD_BUR_SCD3') }} AS ROW_WID
),

exp_row_wid AS (
  SELECT 
    CASE 
      WHEN ROW_WID = 0 THEN {{ mplt_cdm_row_wid('W_CLAIM_CD_BUR_SCD3') }}
      ELSE ROW_WID + 1
    END AS ROW_WID
  FROM mplt_cdm_row_wid
)

SELECT *
FROM exp_row_wid