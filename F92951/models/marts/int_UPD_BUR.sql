-- Purpose: Applies update strategy using expression DD_UPDATE.
WITH upd_bur AS (
    SELECT 
        'DD_UPDATE' AS update_strategy_expression_78066
    FROM 
        {{ ref('int_EXP_Flag') }}
)
SELECT 
    update_strategy_expression_78066
FROM 
    upd_bur