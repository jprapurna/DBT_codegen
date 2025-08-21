-- Purpose: Set flags and timestamps based on lookup results
WITH flag_data AS (
  SELECT 
    IIF(ISNULL(lkp_ROW_WID), 'I', IIF(MD5(BUR) = MD5(lkp_NEW_BUR), 'NC', 'U')) AS o_Flag
  FROM {{ ref('int_lkp_w_claim_cd_bur_scd3') }}
)
SELECT * FROM flag_data