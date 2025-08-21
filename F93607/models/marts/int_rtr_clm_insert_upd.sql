-- Purpose: Routes data based on the value of 'o_Flag'

WITH routed_data AS (
  SELECT 
    o_flag,
    cdm_insert_dt,
    cdm_update_dt,
    tgt_table_name
  FROM {{ ref('int_exp_flag') }}
)

SELECT 
  o_flag,
  cdm_insert_dt,
  cdm_update_dt,
  tgt_table_name
FROM routed_data
WHERE o_flag IN ('I', 'U')