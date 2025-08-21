-- Purpose: Update operations for W_CLAIM_CD_BUR_SCD3
{{ config(materialized='table') }}
WITH update_data AS (
  SELECT 
    ROW_WID,
    POLICY_STATE,
    BUR,
    SOURCE_NAME
  FROM {{ ref('int_cdh_gw_bur') }}
  WHERE o_Flag = 'U'
)
SELECT * FROM update_data