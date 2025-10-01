{{ config(materialized='ephemeral') }}

WITH row_wid_data AS (
  SELECT 
    *,
    {{ macro_lkp_max_row_wid('target_table_name', 'v2') }} AS max_row_wid
  FROM {{ ref('int_cdm__claim_cd_bur_scd3') }}
)

SELECT * FROM row_wid_data