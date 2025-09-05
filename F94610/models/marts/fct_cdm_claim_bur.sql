{{ config(materialized='table') }}

WITH flag_logic AS (
  SELECT *
  FROM {{ ref('int_cdm_flag_logic') }}
),
row_wid_logic AS (
  SELECT 
    ROW_WID
  FROM {{ mplt_CDM_ROW_WID('W_CLAIM_CD_BUR_SCD3') }}
),
insert_update_logic AS (
  SELECT 
    flag_logic.*,
    row_wid_logic.ROW_WID
  FROM flag_logic
  LEFT JOIN row_wid_logic ON flag_logic.TGT_TABLE_NAME = row_wid_logic.TABLE_NAME
)
SELECT *
FROM insert_update_logic