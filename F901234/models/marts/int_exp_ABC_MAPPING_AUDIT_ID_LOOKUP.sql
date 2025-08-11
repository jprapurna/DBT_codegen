-- Purpose: Expression transformation for mapping audit ID lookup
WITH mapping_audit AS (
  SELECT 
    v_RECORD_NUM + 1 AS v_RECORD_NUM,
    IIF(v_RECORD_NUM = 1, :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME), v_MAPNG_ID) AS v_MAPNG_ID,
    IIF(v_RECORD_NUM = 1, 
      IIF(ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)), 
        :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME), 
        :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)
      ), 
      v_WRK_FLOW_RUN_ID
    ) AS v_WRK_FLOW_RUN_ID
)
SELECT 
  v_RECORD_NUM, 
  v_MAPNG_ID, 
  v_WRK_FLOW_RUN_ID 
FROM mapping_audit