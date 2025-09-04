{{ config(materialized='ephemeral') }}

WITH lookup_data AS (
  SELECT
    ROW_WID AS lkp_row_wid,
    INTEGRATION_ID AS lkp_integration_id,
    NEW_BUR AS lkp_new_bur
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
)

SELECT *
FROM lookup_data