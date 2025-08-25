-- Purpose: Derives flags, timestamps, and target table name based on input fields and lookup results.
SELECT 
    INTEGRATION_ID, 
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
    {{ tgt_table_name() }} AS TGT_TABLE_NAME
FROM {{ ref('int_exp_bur') }}
LEFT JOIN {{ ref('int_w_claim_cd_bur_scd3') }} 
ON {{ ref('int_exp_bur') }}.INTEGRATION_ID = {{ ref('int_w_claim_cd_bur_scd3') }}.lkp_INTEGRATION_ID