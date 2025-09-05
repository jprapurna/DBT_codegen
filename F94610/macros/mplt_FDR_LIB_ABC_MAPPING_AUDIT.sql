{% macro mplt_FDR_LIB_ABC_MAPPING_AUDIT(mapping_name, folder_name, workflow_name) %}
WITH record_increment AS (
  SELECT
    v_RECORD_NUM + 1 AS v_RECORD_NUM
  FROM some_table
),
mapping_id_lookup AS (
  SELECT
    CASE 
      WHEN v_RECORD_NUM = 1 THEN :LKP.lkp_MAP_ID(mapping_name, folder_name)
      ELSE v_MAPNG_ID
    END AS v_MAPNG_ID
  FROM record_increment
),
workflow_run_id_lookup AS (
  SELECT
    CASE 
      WHEN v_RECORD_NUM = 1 THEN 
        CASE 
          WHEN ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(workflow_name)) THEN :LKP.lkp_WORKFLOW_RUN_ID(workflow_name)
          ELSE :LKP.LKP_WORKFLOW_RUN_ID_ABC(workflow_name)
        END
      ELSE v_WRK_FLOW_RUN_ID
    END AS v_WRK_FLOW_RUN_ID
  FROM mapping_id_lookup
)
SELECT
  v_MAPNG_ID AS CR_BY_MAPNG_ID,
  SESSSTARTTIME AS DW_CR_TMSP,
  v_MAPNG_ID AS UPD_BY_MAPNG_ID,
  SESSSTARTTIME AS DW_UPD_TMSP,
  v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
FROM workflow_run_id_lookup
{% endmacro %}