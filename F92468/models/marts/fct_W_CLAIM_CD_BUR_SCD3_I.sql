-- Purpose: Insert data into the table W_CLAIM_CD_BUR_SCD3_I
WITH insert_data AS (
    SELECT 
        o_Flag, 
        CDM_INSERT_DT, 
        CDM_UPDATE_DT, 
        TGT_TABLE_NAME, 
        ROW_WID
    FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
    JOIN {{ ref('int_exp_ROW_WID') }} ON TGT_TABLE_NAME = TGT_TABLE_NAME
)
SELECT 
    o_Flag, 
    CDM_INSERT_DT, 
    CDM_UPDATE_DT, 
    TGT_TABLE_NAME, 
    ROW_WID 
FROM insert_data