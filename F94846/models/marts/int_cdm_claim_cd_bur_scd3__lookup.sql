{{
  config(materialized='ephemeral')
}}

WITH lookup_data AS (
  SELECT
    ROW_WID AS lkp_ROW_WID,
    INTEGRATION_ID AS lkp_INTEGRATION_ID,
    NEW_BUR AS lkp_NEW_BUR
  FROM {{ source('cdm_claim_cd_bur_scd3') }}
)

SELECT * FROM lookup_data