{{ config(materialized='ephemeral') }}

WITH exp_row_wid_data AS (
  SELECT 
    CASE 
      WHEN v2 = 0 THEN {{ macro_max_row_wid(ref('schema_cdm'), ref('tgt_table_name')) }} 
      ELSE v2 
    END AS ROW_WID 
  FROM {{ ref('int_claim_cd_bur__exp_flag') }}
)

SELECT * FROM exp_row_wid_data