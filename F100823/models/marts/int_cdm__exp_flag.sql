{{
  config(materialized='ephemeral')
}}

WITH exp_flag AS (
  SELECT 
    {{ macro_flag_logic('lkp_row_wid', 'bur', 'lkp_new_bur') }} AS o_flag,
    CURRENT_TIMESTAMP AS cdm_insert_dt,
    CURRENT_TIMESTAMP AS cdm_update_dt,
    'TGT_TABLE_NAME' AS tgt_table_name
  FROM {{ ref('int_cdm__lookup_claim_cd_bur_scd3') }}
)

SELECT *
FROM exp_flag