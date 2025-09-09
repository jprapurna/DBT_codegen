{% macro mplt_abc_mapping_audit(mapping_name, folder_name, workflow_name) %}
WITH lkp_map_id AS (
  SELECT
    mapping_id
  FROM {{ source('schema', 'table') }}
  WHERE mapping_name = {{ mapping_name }}
    AND folder_name = {{ folder_name }}
),
lkp_workflow_run_id_abc AS (
  SELECT
    workflow_run_id
  FROM {{ source('schema', 'table') }}
  WHERE workflow_name = {{ workflow_name }}
),
lkp_workflow_run_id AS (
  SELECT
    workflow_run_id
  FROM {{ source('schema', 'table') }}
  WHERE workflow_name = {{ workflow_name }}
),
step1 AS (
  SELECT
    IIF(v_RECORD_NUM = 1, lkp_map_id.mapping_id, v_MAPNG_ID) AS v_MAPNG_ID,
    IIF(v_RECORD_NUM = 1,
        IIF(ISNULL(lkp_workflow_run_id_abc.workflow_run_id),
            lkp_workflow_run_id.workflow_run_id,
            lkp_workflow_run_id_abc.workflow_run_id),
        v_WRK_FLOW_RUN_ID) AS v_WRK_FLOW_RUN_ID
  FROM lkp_map_id
  CROSS JOIN lkp_workflow_run_id_abc
  CROSS JOIN lkp_workflow_run_id
),
final AS (
  SELECT
    v_MAPNG_ID AS CR_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_CR_TMSP,
    v_MAPNG_ID AS UPD_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_UPD_TMSP,
    v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
  FROM step1
)
SELECT *
FROM final
{% endmacro %}