{{ config(materialized='ephemeral') }}

WITH exp_flag_data AS (
  SELECT 
    CASE 
      WHEN {{ macro_null_check('LKP_ROW_WID') }} THEN 'I' 
      WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC' 
      ELSE 'U' 
    END AS o_Flag, 
    CURRENT_TIMESTAMP AS CDM_INSERT_DT, 
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT, 
    {{ ref('mapplet_tgt_table_name') }} AS TGT_TABLE_NAME 
  FROM {{ ref('int_claim_cd_bur__lookup') }}
)

SELECT * FROM exp_flag_data