-- Purpose: Update strategy expression.

WITH update_strategy AS (
    SELECT 
        integration_id AS in_integration_id, 
        lkp_integration_id, 
        o_flag, 
        batch_id, 
        o_flag AS o_flag1,
        'DD_UPDATE' AS update_strategy_expression_78066
    FROM {{ ref('int_EXP_Flag') }}
)

SELECT 
    in_integration_id, 
    lkp_integration_id, 
    o_flag, 
    batch_id, 
    o_flag1,
    update_strategy_expression_78066
FROM update_strategy