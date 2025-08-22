-- Purpose: Evaluates input fields and applies expressions to generate output fields such as flags, timestamps, and target table names.
WITH flag_data AS (
  SELECT 
    INTEGRATION_ID,
    BUR,
    SOURCE_NAME,
    o_BATCH_ID,
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    LKP_NEW_BUR,
    CASE 
      WHEN LKP_ROW_WID IS NULL THEN 'I'
      WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag,
    SYSDATE AS CDM_INSERT_DT,
    SYSDATE AS CDM_UPDATE_DT,
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
  FROM {{ ref('int_lkp_w_claim_cd_bur_scd3') }}
)
SELECT * FROM flag_data