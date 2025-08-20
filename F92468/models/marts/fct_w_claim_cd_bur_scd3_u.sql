-- Purpose: Represents the final update operation for W_CLAIM_CD_BUR_SCD3

WITH update_data AS (
  SELECT 
    row_wid,
    cdm_insert_dt,
    cdm_update_dt,
    tgt_table_name
  FROM {{ ref('int_exp_row_wid') }}
  WHERE {{ ref('int_rtr_clm_insert_upd') }}.o_flag = 'U'
)

SELECT 
  row_wid,
  cdm_insert_dt,
  cdm_update_dt,
  tgt_table_name
FROM update_data