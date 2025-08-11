-- Purpose: Lookup transformation for claim code with caching enabled.
WITH lookup_claim_cd_bur_scd3 AS (
  SELECT 
    ROW_WID AS lkp_row_wid,
    INTEGRATION_ID AS lkp_integration_id,
    NEW_BUR AS lkp_new_bur
  FROM {{ source('DBConnection_CDM', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT 
  lkp_row_wid,
  lkp_integration_id,
  lkp_new_bur
FROM lookup_claim_cd_bur_scd3