{% macro mplt_abc_mapping_audit(mapping_name, folder_name, workflow_name) %}
WITH lookup_map_id AS (
  SELECT DISTINCT
    v_MAPNG_ID AS CR_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_CR_TMSP,
    v_MAPNG_ID AS UPD_BY_MAPNG_ID,
    SESSSTARTTIME AS DW_UPD_TMSP,
    v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
  FROM {{ source('GENAI_POWER_BI', 'SOME_TABLE') }}
  WHERE mapping_name = '{{ mapping_name }}'
    AND folder_name = '{{ folder_name }}'
    AND workflow_name = '{{ workflow_name }}'
),
lookup_workflow_run_id AS (
  SELECT DISTINCT
    lkp_WORKFLOW_RUN_ID
  FROM {{ source('GENAI_POWER_BI', 'SOME_TABLE') }}
),
lookup_workflow_run_id_abc AS (
  SELECT DISTINCT
    lkp_WORKFLOW_RUN_ID_ABC
  FROM {{ source('GENAI_POWER_BI', 'SOME_TABLE') }}
)
SELECT
  CR_BY_MAPNG_ID,
  DW_CR_TMSP,
  UPD_BY_MAPNG_ID,
  DW_UPD_TMSP,
  WRK_FLOW_RUN_ID
FROM lookup_map_id
{% endmacro %}
