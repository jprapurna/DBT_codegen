WITH policy_state_bur_mapping AS (
  SELECT 
    POLICY_STATE,
    BUR,
    SOURCE_NAME
  FROM {{ ref('policy_state_bur_mapping') }}
),
lookup_results AS (
  SELECT 
    lkp_ROW_WID,
    lkp_NEW_BUR
  FROM {{ source('W_CLAIM_CD_SCD3_IU', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
  WHERE INTEGRATION_ID = POLICY_STATE
),
batch_id_lookup AS (
  SELECT 
    BATCH_ID
  FROM {{ source('W_CLAIM_CD_SCD3_IU', 'lkp_CDM_BATCH_CTRLID') }}
  WHERE SOURCE_NAME = 'GWCDH'
)
SELECT 
  psbm.POLICY_STATE,
  psbm.BUR,
  psbm.SOURCE_NAME,
  psbm.POLICY_STATE AS INTEGRATION_ID,
  bil.BATCH_ID AS o_BATCH_ID,
  lr.lkp_ROW_WID,
  lr.lkp_NEW_BUR,
  {{ evaluate_flag('psbm.BUR', 'lr.lkp_NEW_BUR', 'lr.lkp_ROW_WID') }} AS o_Flag,
  SYSDATE AS CDM_INSERT_DT,
  SYSDATE AS CDM_UPDATE_DT,
  'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
FROM policy_state_bur_mapping psbm
LEFT JOIN lookup_results lr ON psbm.POLICY_STATE = lr.lkp_ROW_WID
LEFT JOIN batch_id_lookup bil ON psbm.SOURCE_NAME = bil.SOURCE_NAME;