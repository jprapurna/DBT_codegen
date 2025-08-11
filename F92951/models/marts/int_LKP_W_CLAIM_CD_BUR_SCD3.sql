-- Purpose: Lookup transformation using custom SQL query
WITH lookup_data AS (
  SELECT 
    ROW_WID AS lkp_ROW_WID, 
    INTEGRATION_ID AS lkp_INTEGRATION_ID, 
    NEW_BUR AS lkp_NEW_BUR 
  FROM {{ source('IICS', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT 
  lkp_ROW_WID, 
  lkp_INTEGRATION_ID, 
  lkp_NEW_BUR 
FROM lookup_data