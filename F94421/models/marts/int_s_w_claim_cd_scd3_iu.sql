{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdh_gwods', 's_w_claim_cd_scd3_iu') }}
),

lookup_data AS (
  SELECT 
    ROW_WID AS lkp_row_wid,
    INTEGRATION_ID AS lkp_integration_id,
    NEW_BUR AS lkp_new_bur
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

flag_logic AS (
  SELECT 
    *,
    {{ macro_flag_logic('lkp_row_wid', 'BUR', 'lkp_new_bur') }} AS o_flag,
    SYSDATE AS cdm_insert_dt,
    SYSDATE AS cdm_update_dt,
    'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
  FROM source_data
  LEFT JOIN lookup_data ON source_data.integration_id = lookup_data.lkp_integration_id
)

SELECT *
FROM flag_logic