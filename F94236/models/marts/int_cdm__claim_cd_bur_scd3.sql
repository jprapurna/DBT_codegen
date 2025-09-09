{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * 
  FROM {{ source('GENAI_POWER_BI', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
),

lookup_data AS (
  SELECT 
    ROW_WID AS lkp_ROW_WID, 
    INTEGRATION_ID AS lkp_INTEGRATION_ID, 
    NEW_BUR AS lkp_NEW_BUR
  FROM source_data
)

SELECT * 
FROM lookup_data