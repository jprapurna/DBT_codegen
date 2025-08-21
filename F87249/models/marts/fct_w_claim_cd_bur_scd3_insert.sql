-- Purpose: Insert operations for W_CLAIM_CD_BUR_SCD3
{{ config(materialized='table') }}
WITH insert_data AS (
  SELECT 
    {{ surrogate_key(['POLICY_STATE', 'BUR']) }} AS ROW_WID,
    POLICY_STATE,
    BUR,
    SOURCE_NAME
  FROM {{ ref('int_cdh_gw_bur') }}
  WHERE o_Flag = 'I'
)
SELECT * FROM insert_data