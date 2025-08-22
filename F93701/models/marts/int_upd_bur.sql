-- Purpose: Represents an Update Strategy transformation.
WITH update_data AS (
  SELECT 
    in_INTEGRATION_ID,
    LKP_INTEGRATION_ID,
    o_Flag,
    BATCH_ID,
    'DD_UPDATE' AS Update_Strategy_Expression_78066
  FROM {{ ref('int_exp_flag') }}
)
SELECT * FROM update_data