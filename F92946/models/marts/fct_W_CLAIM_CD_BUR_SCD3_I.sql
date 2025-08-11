-- Purpose: Handle insert operations with specific field mappings.
WITH claim_cd_bur_scd3_i AS (
  SELECT 
    INTEGRATION_ID,
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT,
    TGT_TABLE_NAME
  FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
)
SELECT 
  INTEGRATION_ID,
  o_Flag,
  CDM_INSERT_DT,
  CDM_UPDATE_DT,
  TGT_TABLE_NAME
FROM claim_cd_bur_scd3_i