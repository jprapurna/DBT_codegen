-- Purpose: Expression transformation for mapping audit ID lookup
WITH mapping_audit_id_lookup AS (
  SELECT 
    v_RECORD_NUM + 1 AS record_num,
    IIF(v_RECORD_NUM = 1, :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME), v_MAPNG_ID) AS mapng_id,
    IIF(v_RECORD_NUM = 1, 
      IIF(ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)), 
        :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME), 
        :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)
      ), 
      v_WRK_FLOW_RUN_ID
    ) AS wrk_flow_run_id
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT 
  record_num, 
  mapng_id, 
  wrk_flow_run_id
FROM mapping_audit_id_lookup