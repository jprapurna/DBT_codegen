-- Purpose: Replace Update Strategy Transformation

WITH update_data AS (
  SELECT 
    in_INTEGRATION_ID,
    LKP_INTEGRATION_ID,
    o_Flag,
    BATCH_ID,
    o_Flag AS o_Flag1,
    'DD_UPDATE' AS Update_Strategy_Expression_78066
  FROM {{ ref('int_exp_flag') }}
)

SELECT 
  in_INTEGRATION_ID,
  LKP_INTEGRATION_ID,
  o_Flag,
  BATCH_ID,
  o_Flag1,
  Update_Strategy_Expression_78066
FROM update_data