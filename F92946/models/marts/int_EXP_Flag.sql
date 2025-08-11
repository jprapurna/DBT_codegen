-- Purpose: Set flags and timestamps based on lookup results and current system date.
WITH exp_flag AS (
  SELECT 
    INTEGRATION_ID,
    o_BATCH_ID,
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    LKP_NEW_BUR,
    IIF(IsNull(LKP_ROW_WID), 'I', IIF(MD5(BUR) = MD5(LKP_NEW_BUR), 'NC', 'U')) AS o_flag,
    SYSDATE AS cdm_insert_dt,
    SYSDATE AS cdm_update_dt,
    'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
  FROM {{ ref('int_LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT 
  INTEGRATION_ID,
  o_BATCH_ID,
  LKP_ROW_WID,
  LKP_INTEGRATION_ID,
  LKP_NEW_BUR,
  o_flag,
  cdm_insert_dt,
  cdm_update_dt,
  tgt_table_name
FROM exp_flag