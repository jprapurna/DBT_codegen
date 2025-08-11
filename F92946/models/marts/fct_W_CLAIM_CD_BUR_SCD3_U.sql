-- Purpose: Update data based on the Update Strategy Expression.
WITH claim_cd_bur_scd3_u AS (
  SELECT 
    INTEGRATION_ID,
    o_Flag,
    BATCH_ID,
    o_Flag1,
    update_strategy_expression_78066
  FROM {{ ref('int_UPD_BUR') }}
)
SELECT 
  INTEGRATION_ID,
  o_Flag,
  BATCH_ID,
  o_Flag1,
  update_strategy_expression_78066
FROM claim_cd_bur_scd3_u