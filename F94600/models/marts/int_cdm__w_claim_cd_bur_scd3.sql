{{ config(materialized='ephemeral') }}

WITH lookup_data AS (
  SELECT 
    row_wid AS lkp_row_wid,
    integration_id AS lkp_integration_id,
    new_bur AS lkp_new_bur
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
)

SELECT * FROM lookup_data