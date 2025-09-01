{% macro mplt_cdm_row_wid(tgt_table_name) %}
WITH lkp_max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ tgt_table_name }}' AS TABLE_NAME
  FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_MAX_ROW_WID') }}
  WHERE TABLE_NAME = '{{ tgt_table_name }}'
)
SELECT ROW_WID
FROM lkp_max_row_wid
{% endmacro %}