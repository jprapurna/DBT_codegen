-- Purpose: Expression transformation for audit ID lookup, utilizing local variables and lookup procedures to determine mapping and workflow run IDs

WITH audit_lookup AS (
  SELECT 
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    IIF(v_RECORD_NUM = 1, 
      IIF(ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)), 
        :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME), 
        :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)), 
      v_WRK_FLOW_RUN_ID) AS v_WRK_FLOW_RUN_ID,
    SESSSTARTTIME AS DW_CR_TMSP,
    SESSSTARTTIME AS DW_UPD_TMSP
  FROM 
    {{ ref('source_model') }}
)

SELECT 
  MAPPING_NAME,
  FOLDER_NAME,
  WORKFLOW_NAME,
  v_MAPNG_ID AS CR_BY_MAPNG_ID,
  v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID,
  DW_CR_TMSP,
  v_MAPNG_ID AS UPD_BY_MAPNG_ID,
  DW_UPD_TMSP
FROM 
  audit_lookup