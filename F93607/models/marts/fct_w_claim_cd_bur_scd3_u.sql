-- Purpose: Represents the target table where data is written

WITH final_data AS (
  SELECT 
    in_integration_id,
    lkp_integration_id,
    o_flag,
    batch_id,
    row_wid
  FROM {{ ref('int_upd_bur') }} AS upd
  JOIN {{ ref('int_mplt_cdm_row_wid') }} AS row_wid
    ON upd.tgt_table_name = row_wid.tgt_table_name
)

SELECT 
  in_integration_id,
  lkp_integration_id,
  o_flag,
  batch_id,
  row_wid
FROM final_data