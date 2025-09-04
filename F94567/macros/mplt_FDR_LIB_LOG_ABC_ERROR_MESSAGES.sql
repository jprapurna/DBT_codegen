{% macro mplt_FDR_LIB_LOG_ABC_ERROR_MESSAGES(v_RECORD_NUM, MSG_ID, WRKFL_CMPNT_ID, WRKFL_RUN_ID) %}
WITH assign_error_id_and_values AS (
  SELECT
    CASE 
      WHEN {{ v_RECORD_NUM }} IS NULL THEN 1
      ELSE {{ v_RECORD_NUM }} + 1
    END AS v_RECORD_NUM,
    {{ MSG_ID }} AS MSG_ID,
    {{ WRKFL_CMPNT_ID }} AS WRKFL_CMPNT_ID,
    {{ WRKFL_RUN_ID }} AS WRKFL_RUN_ID
)
SELECT 
  v_RECORD_NUM,
  MSG_ID,
  WRKFL_CMPNT_ID,
  WRKFL_RUN_ID
FROM assign_error_id_and_values
{% endmacro %}