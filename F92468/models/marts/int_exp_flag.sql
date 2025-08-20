-- Purpose: Sets flags and timestamps based on lookup results and current system date

WITH flag_data AS (
  SELECT 
    IIF(IsNull(lkp_row_wid), 'I', IIF(MD5(bur) = MD5(lkp_new_bur), 'NC', 'U')) AS o_flag,
    SYSDATE AS cdm_insert_dt,
    SYSDATE AS cdm_update_dt,
    'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
  FROM {{ ref('int_lkp_w_claim_cd_bur_scd3') }}
)

SELECT 
  o_flag,
  cdm_insert_dt,
  cdm_update_dt,
  tgt_table_name
FROM flag_data