SELECT 
    INTEGRATION_ID, 
    o_BATCH_ID, 
    LKP_ROW_WID, 
    LKP_INTEGRATION_ID, 
    LKP_NEW_BUR,
    CASE 
        WHEN LKP_ROW_WID IS NULL THEN 'I'
        WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
        ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    '{{ tgt_table_name() }}' AS TGT_TABLE_NAME
FROM {{ ref('int_w_claim_cd_bur_scd3') }}