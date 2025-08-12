-- Purpose: Expression transformation replacing Update Strategy Transformation
WITH update_data AS (
  SELECT 
    in_INTEGRATION_ID, 
    LKP_INTEGRATION_ID, 
    o_Flag, 
    BATCH_ID, 
    o_Flag1,
    'DD_UPDATE' AS update_strategy_expression_78066
  FROM 
    {{ ref('int_EXP_Flag') }}
)
SELECT 
  in_INTEGRATION_ID, 
  LKP_INTEGRATION_ID, 
  o_Flag, 
  BATCH_ID, 
  o_Flag1, 
  update_strategy_expression_78066
FROM 
  update_data