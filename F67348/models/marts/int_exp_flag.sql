-- Purpose: Expression transformation to set flags and timestamps based on lookup results.
SELECT 
    IIF(ISNULL(lkp_ROW_WID), 'I', IIF(MD5(BUR) = MD5(lkp_NEW_BUR), 'NC', 'U')) AS o_Flag,
    SYSDATE AS CDM_INSERT_DT,
    SYSDATE AS CDM_UPDATE_DT,
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
FROM {{ ref('int_exp_bur') }}
LEFT JOIN {{ ref('int_lkp_w_claim_cd_bur_scd3') }} 
ON {{ ref('int_exp_bur') }}.POLICY_STATE = {{ ref('int_lkp_w_claim_cd_bur_scd3') }}.lkp_INTEGRATION_ID