-- Purpose: Mapplet transformation for auditing mapping details, including lookup procedures for mapping and workflow IDs.

WITH map_id_lookup AS (
  SELECT
    MAPPING_NAME,
    FOLDER_NAME,
    :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME) AS v_MAPNG_ID
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
),
workflow_run_id_lookup AS (
  SELECT
    WORKFLOW_NAME,
    IIF(ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)), :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME), :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)) AS v_WRK_FLOW_RUN_ID
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
  MAPPING_NAME,
  FOLDER_NAME,
  WORKFLOW_NAME,
  IIF(v_RECORD_NUM = 1, map_id_lookup.v_MAPNG_ID, v_MAPNG_ID) AS CR_BY_MAPNG_ID,
  SESSSTARTTIME AS DW_CR_TMSP,
  UPD_BY_MAPNG_ID,
  DW_UPD_TMSP,
  IIF(v_RECORD_NUM = 1, workflow_run_id_lookup.v_WRK_FLOW_RUN_ID, v_WRK_FLOW_RUN_ID) AS WRK_FLOW_RUN_ID
FROM map_id_lookup
JOIN workflow_run_id_lookup ON map_id_lookup.MAPPING_NAME = workflow_run_id_lookup.WORKFLOW_NAME