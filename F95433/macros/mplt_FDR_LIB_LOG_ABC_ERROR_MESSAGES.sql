{% macro mplt_FDR_LIB_LOG_ABC_ERROR_MESSAGES(err_desc, wrkfl_mapng_id, err_resolution_tmsp, wrkfl_run_id, wrkfl_cmpnt_id, std_msg_id, err_stat, wrkfl_nm, msg_id, wrkfl_cmpnt_nm, msg_tmsp, cmpnt_module_nm, cmpnt_module_pk) %}
WITH error_data AS (
  SELECT
    '{{ err_desc }}' AS ERR_DESC,
    '{{ wrkfl_mapng_id }}' AS WRKFL_MAPNG_ID,
    '{{ err_resolution_tmsp }}' AS ERR_RESOLUTION_TMSP,
    '{{ wrkfl_run_id }}' AS WRKFL_RUN_ID,
    '{{ wrkfl_cmpnt_id }}' AS WRKFL_CMPNT_ID,
    '{{ std_msg_id }}' AS STD_MSG_ID,
    '{{ err_stat }}' AS ERR_STAT,
    '{{ wrkfl_nm }}' AS WRKFL_NM,
    '{{ msg_id }}' AS MSG_ID,
    '{{ wrkfl_cmpnt_nm }}' AS WRKFL_CMPNT_NM,
    '{{ msg_tmsp }}' AS MSG_TMSP,
    '{{ cmpnt_module_nm }}' AS CMPNT_MODULE_NM,
    '{{ cmpnt_module_pk }}' AS CMPNT_MODULE_PK
)
SELECT * FROM error_data
{% endmacro %}