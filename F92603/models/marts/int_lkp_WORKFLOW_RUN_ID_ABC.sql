-- Purpose: Lookup procedure for workflow run ID
WITH workflow_run_id_abc_lookup AS (
  SELECT 
    LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME) AS workflow_run_id_abc
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT 
  workflow_run_id_abc
FROM workflow_run_id_abc_lookup