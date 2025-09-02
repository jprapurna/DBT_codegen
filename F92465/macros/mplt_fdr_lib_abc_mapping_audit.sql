{% macro mplt_fdr_lib_abc_mapping_audit(mapping_name, folder_name, workflow_name) %}
WITH lkp_MAP_ID AS (
  SELECT
    MAP_ID
  FROM {{ source('schema', 'table') }}
  WHERE MAPPING_NAME = FOLDER_NAME
),
lkp_WORKFLOW_RUN_ID_ABC AS (
  SELECT
    WORKFLOW_RUN_ID
  FROM {{ source('schema', 'table') }}
  WHERE WORKFLOW_NAME = WORKFLOW_RUN_ID
),
final AS (
  SELECT
    v_MAPNG_ID AS CR_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_CR_TMSP,
    v_MAPNG_ID AS UPD_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_UPD_TMSP,
    v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
  FROM lkp_MAP_ID
  JOIN lkp_WORKFLOW_RUN_ID_ABC ON lkp_MAP_ID.MAP_ID = lkp_WORKFLOW_RUN_ID_ABC.WORKFLOW_RUN_ID
)
SELECT * FROM final
{% endmacro %}