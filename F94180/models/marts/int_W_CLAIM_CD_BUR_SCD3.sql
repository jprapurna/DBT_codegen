-- Purpose: Lookup transformation for table CDM.W_CLAIM_CD_BUR_SCD3.
SELECT 
  ROW_WID AS lkp_ROW_WID,
  INTEGRATION_ID AS lkp_INTEGRATION_ID,
  NEW_BUR AS lkp_NEW_BUR
FROM {{ source('CDM', 'DUMMY_LKP_W_CLAIM_CD_BUR_SCD3') }}