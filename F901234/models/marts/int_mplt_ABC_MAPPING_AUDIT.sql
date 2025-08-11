-- Purpose: Mapplet for auditing mapping details, including mapping name, folder name, and workflow name
WITH audit_data AS (
  SELECT 
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    CR_BY_MAPNG_ID,
    CURRENT_TIMESTAMP() AS dw_cr_tmsp,
    UPD_BY_MAPNG_ID,
    CURRENT_TIMESTAMP() AS dw_upd_tmsp,
    WRK_FLOW_RUN_ID
)
SELECT 
  MAPPING_NAME,
  FOLDER_NAME,
  WORKFLOW_NAME,
  CR_BY_MAPNG_ID,
  dw_cr_tmsp,
  UPD_BY_MAPNG_ID,
  dw_upd_tmsp,
  WRK_FLOW_RUN_ID
FROM audit_data