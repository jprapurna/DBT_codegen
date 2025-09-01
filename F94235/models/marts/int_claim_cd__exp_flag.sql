{{ config(materialized='ephemeral') }}

WITH flag_data AS (
  SELECT 
    {{ macro_flag_logic('LKP_ROW_WID', 'BUR', 'LKP_NEW_BUR') }} AS o_Flag,
    SYSDATE AS CDM_INSERT_DT,
    SYSDATE AS CDM_UPDATE_DT,
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
  FROM {{ ref('int_claim_cd__lkp_w_claim_cd_bur_scd3') }}
)
SELECT * FROM flag_data