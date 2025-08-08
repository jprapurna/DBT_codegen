-- Purpose: Update operation on the table W_CLAIM_CD_BUR_SCD3_U.

WITH update_strategy AS (
    SELECT 
        in_integration_id, 
        lkp_integration_id, 
        o_flag, 
        batch_id, 
        o_flag1,
        update_strategy_expression_78066
    FROM {{ ref('int_UPD_BUR') }}
)

SELECT 
    in_integration_id, 
    lkp_integration_id, 
    o_flag, 
    batch_id, 
    o_flag1,
    update_strategy_expression_78066
FROM update_strategy