-- Purpose: Update strategy expression
SELECT 
    in_INTEGRATION_ID, 
    LKP_INTEGRATION_ID, 
    o_Flag, 
    BATCH_ID, 
    o_Flag1, 
    'DD_UPDATE' AS Update_Strategy_Expression_78066 
FROM {{ ref('int_EXP_Flag') }}