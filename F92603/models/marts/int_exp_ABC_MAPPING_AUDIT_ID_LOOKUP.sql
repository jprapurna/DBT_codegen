-- Purpose: Expression transformation for mapping audit ID lookup.
WITH mapping_audit_id_lookup AS (
  SELECT 
    v_RECORD_NUM + 1 AS record_num,
    IIF(v_RECORD_NUM = 1, lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME), v_MAPNG_ID) AS map_id,
    IIF(v_RECORD_NUM = 1, 
      IIF(ISNULL(lkp_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)), 
        lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME), 
        lkp_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)
      ), 
      v_WRK_FLOW_RUN_ID
    ) AS workflow_run_id
)
SELECT 
  record_num,
  map_id,
  workflow_run_id
FROM mapping_audit_id_lookup