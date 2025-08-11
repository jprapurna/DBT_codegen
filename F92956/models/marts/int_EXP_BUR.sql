-- Purpose: Rename POLICY_STATE to INTEGRATION_ID and derive flags and timestamps.

WITH source_data AS (
    SELECT 
        POLICY_STATE AS INTEGRATION_ID,
        BUR,
        o_BATCH_ID,
        LKP_ROW_WID,
        LKP_INTEGRATION_ID,
        LKP_NEW_BUR
    FROM {{ ref('int_CDH_GW_BUR') }}
)

SELECT 
    INTEGRATION_ID,
    o_BATCH_ID,
    LKP_ROW_WID,
    LKP_INTEGRATION_ID,
    LKP_NEW_BUR,
    IIF(ISNULL(LKP_ROW_WID), 'I', IIF(MD5(BUR) = MD5(LKP_NEW_BUR), 'NC', 'U')) AS o_Flag,
    CURRENT_TIMESTAMP() AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP() AS CDM_UPDATE_DT,
    'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
FROM source_data