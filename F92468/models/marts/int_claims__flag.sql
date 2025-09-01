{{ config(materialized='ephemeral') }}

WITH flag_data AS (
  SELECT 
    INTEGRATION_ID, 
    LKP_ROW_WID, 
    LKP_NEW_BUR, 
    {{ macro_flag_logic(INTEGRATION_ID, LKP_ROW_WID, LKP_NEW_BUR, BUR) }} AS o_Flag,
    CURRENT_DATE AS CDM_INSERT_DT,
    CURRENT_DATE AS CDM_UPDATE_DT,
    'TARGET_TABLE' AS TGT_TABLE_NAME
  FROM {{ ref('int_claims__lookup') }}
)
SELECT * FROM flag_data