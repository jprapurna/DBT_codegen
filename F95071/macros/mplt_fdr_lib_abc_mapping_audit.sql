{% macro mplt_fdr_lib_abc_mapping_audit(mapping_name, folder_name, workflow_name) %}
WITH lkp_map_id AS (
  SELECT
    map_id
  FROM {{ source('schema', 'table') }}
  WHERE mapping_name = folder_name
),
lkp_workflow_run_id AS (
  SELECT
    workflow_run_id
  FROM {{ source('schema', 'table') }}
  WHERE workflow_name = workflow_name
),
lkp_workflow_run_id_abc AS (
  SELECT
    workflow_run_id_abc
  FROM {{ source('schema', 'table') }}
  WHERE workflow_name = workflow_name
),
final AS (
  SELECT
    CASE 
      WHEN v_RECORD_NUM = 1 THEN (SELECT map_id FROM lkp_map_id)
      ELSE v_MAPNG_ID
    END AS v_MAPNG_ID,
    CASE 
      WHEN v_RECORD_NUM = 1 THEN 
        CASE 
          WHEN (SELECT workflow_run_id_abc FROM lkp_workflow_run_id_abc) IS NULL THEN (SELECT workflow_run_id FROM lkp_workflow_run_id)
          ELSE (SELECT workflow_run_id_abc FROM lkp_workflow_run_id_abc)
        END
      ELSE v_WRK_FLOW_RUN_ID
    END AS v_WRK_FLOW_RUN_ID,
    v_MAPNG_ID AS CR_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_CR_TMSP,
    v_MAPNG_ID AS UPD_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_UPD_TMSP,
    v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
  FROM input_table
)
SELECT *
FROM final
{% endmacro %}