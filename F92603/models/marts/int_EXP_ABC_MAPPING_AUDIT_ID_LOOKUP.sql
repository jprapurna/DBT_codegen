-- Purpose: Determine mapping and workflow run IDs using local variables and lookup procedures.

SELECT 
    {{ ref('MAPPING_NAME') }} AS mapping_name,
    {{ ref('FOLDER_NAME') }} AS folder_name,
    {{ ref('WORKFLOW_NAME') }} AS workflow_name,
    {{ ref('v_MAPNG_ID') }} AS upd_by_mapng_id,
    {{ ref('v_WRK_FLOW_RUN_ID') }} AS wrk_flow_run_id,
    CURRENT_TIMESTAMP() AS dw_cr_tmsp,
    CURRENT_TIMESTAMP() AS dw_upd_tmsp