{{
  config(materialized='table')
}}

WITH rtr_clm_insert_upd_data AS (
  SELECT * FROM {{ ref('int_rtr_clm_insert_upd') }}
),

assignment_pc_variables_data AS (
  SELECT * FROM {{ ref('int_assignment_pc_variables') }}
),

exp_row_wid_data AS (
  SELECT * FROM {{ ref('int_exp_row_wid') }}
)

SELECT
  rtr_clm_insert_upd_data.POLICY_STATE,
  rtr_clm_insert_upd_data.BUR_CLEANED,
  rtr_clm_insert_upd_data.SOURCE_NAME,
  rtr_clm_insert_upd_data.STATE_FLAG,
  rtr_clm_insert_upd_data.ACTION,
  assignment_pc_variables_data.ASSIGNMENT_STATUS,
  exp_row_wid_data.ROW_WID
FROM rtr_clm_insert_upd_data
LEFT JOIN assignment_pc_variables_data
  ON rtr_clm_insert_upd_data.SOURCE_NAME = assignment_pc_variables_data.SOURCE_NAME
LEFT JOIN exp_row_wid_data
  ON rtr_clm_insert_upd_data.BUR_CLEANED = exp_row_wid_data.NEW_BUR_CLEANED;