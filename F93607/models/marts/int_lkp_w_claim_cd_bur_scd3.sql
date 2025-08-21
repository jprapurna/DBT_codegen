-- Purpose: Lookup transformation for table CDM.W_CLAIM_CD_BUR_SCD3 using custom SQL query

WITH lookup_data AS (
  SELECT 
    ROW_WID AS lkp_row_wid,
    INTEGRATION_ID AS lkp_integration_id,
    NEW_BUR AS lkp_new_bur
  FROM {{ source('CDH_GWODS', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)

SELECT 
  lkp_row_wid,
  lkp_integration_id,
  lkp_new_bur
FROM lookup_data