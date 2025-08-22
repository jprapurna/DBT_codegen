-- Purpose: Lookup transformation to fetch fields ROW_WID, INTEGRATION_ID, and NEW_BUR from source table CDM.W_CLAIM_CD_BUR_SCD3.
WITH lookup_data AS (
  SELECT 
    ROW_WID AS lkp_ROW_WID,
    INTEGRATION_ID AS lkp_INTEGRATION_ID,
    NEW_BUR AS lkp_NEW_BUR
  FROM {{ source('genai_power_bi', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT * FROM lookup_data