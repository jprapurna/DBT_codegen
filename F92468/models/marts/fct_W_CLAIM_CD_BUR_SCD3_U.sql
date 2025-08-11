-- Purpose: Update operation on the table W_CLAIM_CD_BUR_SCD3_U
WITH update_data AS (
    SELECT 
        in_INTEGRATION_ID, 
        LKP_INTEGRATION_ID, 
        o_Flag, 
        BATCH_ID, 
        o_Flag1, 
        Update_Strategy_Expression_78066
    FROM {{ ref('int_UPD_BUR') }}
)
SELECT 
    in_INTEGRATION_ID, 
    LKP_INTEGRATION_ID, 
    o_Flag, 
    BATCH_ID, 
    o_Flag1, 
    Update_Strategy_Expression_78066 
FROM update_data