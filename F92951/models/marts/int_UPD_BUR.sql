-- Purpose: Update strategy expression
WITH update_strategy AS (
  SELECT 
    'DD_UPDATE' AS Update_Strategy_Expression_78066 
  FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
  WHERE o_Flag = 'U'
)
SELECT 
  Update_Strategy_Expression_78066 
FROM update_strategy