-- Purpose: Calculates flags, timestamps, and target table name based on input fields and lookup results

WITH flag_data AS (
  SELECT 
    a.integration_id,
    a.bur,
    a.source_name,
    b.batch_id AS o_batch_id,
    c.lkp_row_wid,
    c.lkp_integration_id,
    c.lkp_new_bur
  FROM {{ ref('int_exp_bur') }} AS a
  LEFT JOIN {{ ref('int_lkp_cdm_batch_ctrlid') }} AS b
    ON a.source_name = b.source_name
  LEFT JOIN {{ ref('int_lkp_w_claim_cd_bur_scd3') }} AS c
    ON a.integration_id = c.lkp_integration_id
)

SELECT 
  integration_id,
  bur,
  source_name,
  o_batch_id,
  lkp_row_wid,
  lkp_integration_id,
  lkp_new_bur,
  CASE 
    WHEN lkp_row_wid IS NULL THEN 'I'
    WHEN MD5(bur) = MD5(lkp_new_bur) THEN 'NC'
    ELSE 'U'
  END AS o_flag,
  CURRENT_TIMESTAMP() AS cdm_insert_dt,
  CURRENT_TIMESTAMP() AS cdm_update_dt,
  'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
FROM flag_data