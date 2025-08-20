-- Purpose: Represents the final insert operation for W_CLAIM_CD_BUR_SCD3

WITH insert_data AS (
  SELECT 
    row_wid,
    cdm_insert_dt,
    cdm_update_dt,
    tgt_table_name
  FROM {{ ref('int_exp_row_wid') }}
  WHERE {{ ref('int_rtr_clm_insert_upd') }}.o_flag = 'I'
)

SELECT 
  row_wid,
  cdm_insert_dt,
  cdm_update_dt,
  tgt_table_name
FROM insert_data