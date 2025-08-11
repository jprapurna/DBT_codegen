-- Purpose: Mapplet transformation for auditing mapping details, including lookup procedures for mapping and workflow IDs.

WITH mapping_audit AS (
  SELECT
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
  FROM
    {{ source('FDR', 'ABC_MAPPING_AUDIT') }}
)

SELECT
  source.MAPPING_NAME,
  source.FOLDER_NAME,
  source.WORKFLOW_NAME,
  IIF(v_RECORD_NUM = 1, :LKP.lkp_MAP_ID(source.MAPPING_NAME, source.FOLDER_NAME), v_MAPNG_ID) AS CR_BY_MAPNG_ID,
  IIF(v_RECORD_NUM = 1, IIF(ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(source.WORKFLOW_NAME)), :LKP.lkp_WORKFLOW_RUN_ID(source.WORKFLOW_NAME), :LKP.LKP_WORKFLOW_RUN_ID_ABC(source.WORKFLOW_NAME)), v_WRK_FLOW_RUN_ID) AS WRK_FLOW_RUN_ID
FROM
  {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }} AS source
LEFT JOIN
  mapping_audit
ON
  source.MAPPING_NAME = mapping_audit.MAPPING_NAME