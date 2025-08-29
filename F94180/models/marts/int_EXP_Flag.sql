-- Purpose: Calculates flags, timestamps, and target table name based on input fields and lookup results.
SELECT 
  INTEGRATION_ID,
  SOURCE_NAME,
  o_BATCH_ID,
  LKP_ROW_WID,
  LKP_INTEGRATION_ID,
  LKP_NEW_BUR,
  CASE 
    WHEN LKP_ROW_WID IS NULL THEN 'I'
    WHEN {{ hash_compare('BUR', 'LKP_NEW_BUR') }} THEN 'NC'
    ELSE 'U'
  END AS o_Flag,
  SYSDATE AS CDM_INSERT_DT,
  SYSDATE AS CDM_UPDATE_DT,
  'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
FROM {{ ref('int_EXP_BUR') }}