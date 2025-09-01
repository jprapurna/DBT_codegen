{{ config(materialized='ephemeral') }}

WITH lookup_data AS (
  SELECT 
    ROW_WID AS LKP_ROW_WID, 
    INTEGRATION_ID AS LKP_INTEGRATION_ID, 
    NEW_BUR AS LKP_NEW_BUR
  FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT * FROM lookup_data