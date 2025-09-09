{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    ROW_WID AS lkp_ROW_WID, 
    INTEGRATION_ID AS lkp_INTEGRATION_ID, 
    NEW_BUR AS lkp_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),
exp_flag AS (
  SELECT 
    *,
    CASE 
      WHEN ISNULL(lkp_ROW_WID) THEN 'I'
      WHEN MD5(BUR) = MD5(lkp_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT
  FROM source_data
),
rtr_clm_insert_upd AS (
  SELECT *
  FROM exp_flag
  WHERE o_Flag IN ('I', 'U')
),
upd_bur AS (
  SELECT 
    *,
    CASE 
      WHEN o_Flag = 'U' THEN BUR
      ELSE NULL
    END AS NEW_BUR
  FROM rtr_clm_insert_upd
),
mplt_row_wid AS (
  SELECT 
    ROW_WID
  FROM {{ mplt_CDM_ROW_WID('W_CLAIM_CD_BUR_SCD3') }}
)
SELECT *
FROM upd_bur