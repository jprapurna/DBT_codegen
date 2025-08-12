-- Purpose: Update strategy expression
WITH update_strategy_data AS (
    SELECT 
        'DD_UPDATE' AS update_strategy_expression_78066
    FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
    update_strategy_expression_78066
FROM update_strategy_data