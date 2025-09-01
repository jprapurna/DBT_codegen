{{ config(materialized='ephemeral') }}

WITH lookup_data AS (
  SELECT 
    ROW_WID AS LKP_ROW_WID,
    INTEGRATION_ID AS LKP_INTEGRATION_ID,
    NEW_BUR AS LKP_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
)
SELECT * FROM lookup_data