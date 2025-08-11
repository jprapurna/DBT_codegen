-- Purpose: Set flags and timestamps based on lookup results and current system date
WITH flag_data AS (
    SELECT 
        INTEGRATION_ID, 
        o_BATCH_ID, 
        LKP_ROW_WID, 
        LKP_INTEGRATION_ID, 
        LKP_NEW_BUR,
        IIF(ISNULL(LKP_ROW_WID), 'I', IIF(MD5(BUR) = MD5(LKP_NEW_BUR), 'NC', 'U')) AS o_Flag,
        SYSDATE AS CDM_INSERT_DT,
        SYSDATE AS CDM_UPDATE_DT,
        'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
    FROM {{ ref('int_EXP_BUR') }}
    JOIN {{ ref('int_LKP_W_CLAIM_CD_BUR_SCD3') }} ON LKP_INTEGRATION_ID = INTEGRATION_ID
)
SELECT 
    INTEGRATION_ID, 
    o_BATCH_ID, 
    LKP_ROW_WID, 
    LKP_INTEGRATION_ID, 
    LKP_NEW_BUR, 
    o_Flag, 
    CDM_INSERT_DT, 
    CDM_UPDATE_DT, 
    TGT_TABLE_NAME 
FROM flag_data