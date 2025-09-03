{% macro mplt_log_abc_error_messages(WRKFL_NM, WRKFL_CMPNT_NM, CMPNT_MODULE_NM, SYS_MSG_CD, ERR_DESC, CMPNT_MODULE_PK, MAPPING_NAME, FOLDER_NAME) %}
WITH input_data AS (
  SELECT
    '{{ WRKFL_NM }}' AS WRKFL_NM,
    '{{ WRKFL_CMPNT_NM }}' AS WRKFL_CMPNT_NM,
    '{{ CMPNT_MODULE_NM }}' AS CMPNT_MODULE_NM,
    '{{ SYS_MSG_CD }}' AS SYS_MSG_CD,
    '{{ ERR_DESC }}' AS ERR_DESC,
    '{{ CMPNT_MODULE_PK }}' AS CMPNT_MODULE_PK,
    '{{ MAPPING_NAME }}' AS MAPPING_NAME,
    '{{ FOLDER_NAME }}' AS FOLDER_NAME
),

lookup_std_msg_id AS (
  SELECT
    STD_MSG_ID,
    SYS_MSG_CD
  FROM {{ source('ABC_CTRL_SYS_STD_MSGS') }}
  WHERE SYS_MSG_CD = '{{ SYS_MSG_CD }}'
),

assign_error_values AS (
  SELECT
    input_data.WRKFL_NM,
    input_data.WRKFL_CMPNT_NM,
    input_data.CMPNT_MODULE_NM,
    input_data.SYS_MSG_CD,
    input_data.ERR_DESC,
    input_data.CMPNT_MODULE_PK,
    input_data.MAPPING_NAME,
    input_data.FOLDER_NAME,
    lookup_std_msg_id.STD_MSG_ID,
    CURRENT_TIMESTAMP AS MSG_TMSP,
    'ERROR' AS ERR_STAT,
    NULL AS ERR_RESOLUTION_TMSP,
    ROW_NUMBER() OVER (PARTITION BY input_data.WRKFL_NM ORDER BY input_data.WRKFL_CMPNT_NM) AS WRKFL_CMPNT_ID,
    ROW_NUMBER() OVER (PARTITION BY input_data.WRKFL_NM ORDER BY input_data.WRKFL_CMPNT_NM) AS WRKFL_RUN_ID,
    CONCAT(input_data.WRKFL_NM, '_', input_data.WRKFL_CMPNT_NM) AS WRKFL_MAPNG_ID
  FROM input_data
  LEFT JOIN lookup_std_msg_id
  ON input_data.SYS_MSG_CD = lookup_std_msg_id.SYS_MSG_CD
),

insert_error_record AS (
  SELECT
    assign_error_values.WRKFL_NM,
    assign_error_values.WRKFL_CMPNT_NM,
    assign_error_values.CMPNT_MODULE_NM,
    assign_error_values.SYS_MSG_CD,
    assign_error_values.ERR_DESC,
    assign_error_values.CMPNT_MODULE_PK,
    assign_error_values.MAPPING_NAME,
    assign_error_values.FOLDER_NAME,
    assign_error_values.STD_MSG_ID,
    assign_error_values.MSG_TMSP,
    assign_error_values.ERR_STAT,
    assign_error_values.ERR_RESOLUTION_TMSP,
    assign_error_values.WRKFL_CMPNT_ID,
    assign_error_values.WRKFL_RUN_ID,
    assign_error_values.WRKFL_MAPNG_ID
  WHERE assign_error_values.ERR_STAT = 'ERROR'
)

SELECT *
FROM insert_error_record
{% endmacro %}