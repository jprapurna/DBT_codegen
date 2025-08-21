-- Purpose: Applies the DD_UPDATE strategy to update records in the target

WITH update_data AS (
  SELECT 
    in_integration_id,
    lkp_integration_id,
    o_flag,
    batch_id
  FROM {{ ref('int_rtr_clm_insert_upd') }}
)

SELECT 
  in_integration_id,
  lkp_integration_id,
  o_flag,
  batch_id
FROM update_data
WHERE o_flag = 'U'