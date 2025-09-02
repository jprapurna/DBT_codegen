{% macro mplt_abc_mapping_audit(mapping_name, folder_name, workflow_name) %}
WITH step1 AS (
  SELECT
    {{ mapping_name }} AS CR_BY_MAPNG_ID,
    {{ workflow_name }} AS DW_CR_TMSP,
    {{ mapping_name }} AS UPD_BY_MAPNG_ID,
    {{ workflow_name }} AS DW_UPD_TMSP,
    {{ folder_name }} AS WRK_FLOW_RUN_ID
)
SELECT
  CR_BY_MAPNG_ID,
  DW_CR_TMSP,
  UPD_BY_MAPNG_ID,
  DW_UPD_TMSP,
  WRK_FLOW_RUN_ID
FROM step1
{% endmacro %}