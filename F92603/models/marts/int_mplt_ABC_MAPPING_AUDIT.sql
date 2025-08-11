-- Purpose: Mapplet for auditing mapping details, including mapping name, folder name, and workflow name
WITH mapping_audit AS (
  SELECT 
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    CR_BY_MAPNG_ID,
    CURRENT_TIMESTAMP() AS DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    CURRENT_TIMESTAMP() AS DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
)
SELECT 
  MAPPING_NAME,
  FOLDER_NAME,
  WORKFLOW_NAME,
  CR_BY_MAPNG_ID,
  DW_CR_TMSP,
  UPD_BY_MAPNG_ID,
  DW_UPD_TMSP,
  WRK_FLOW_RUN_ID
FROM mapping_audit