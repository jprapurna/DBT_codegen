{{ config(materialized='table') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

scd3_logic_step AS (
  SELECT
    ROW_WID AS lkp_ROW_WID,
    INTEGRATION_ID AS lkp_INTEGRATION_ID,
    NEW_BUR AS lkp_NEW_BUR
  FROM source_data
)

SELECT *
FROM scd3_logic_step