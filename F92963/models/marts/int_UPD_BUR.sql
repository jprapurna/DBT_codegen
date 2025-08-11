-- Purpose: Update strategy for business unit reference
WITH update_data AS (
    SELECT 
        in_INTEGRATION_ID, 
        LKP_INTEGRATION_ID, 
        o_Flag, 
        BATCH_ID,
        'DD_UPDATE' AS update_strategy_expression_78066
    FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
    in_INTEGRATION_ID, 
    LKP_INTEGRATION_ID, 
    o_Flag, 
    BATCH_ID, 
    update_strategy_expression_78066
FROM update_data