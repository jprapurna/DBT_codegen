-- Purpose: Lookup procedure for workflow run ID
WITH workflow_run_id_lookup AS (
  SELECT 
    lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME) AS workflow_run_id
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT 
  workflow_run_id
FROM workflow_run_id_lookup