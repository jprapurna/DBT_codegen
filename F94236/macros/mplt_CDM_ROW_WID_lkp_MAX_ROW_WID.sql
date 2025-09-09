{% macro mplt_CDM_ROW_WID_lkp_MAX_ROW_WID(tgt_table_name, schema_cdm) %}
WITH max_row_wid_lookup AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    {{ tgt_table_name }} AS TABLE_NAME
  FROM {{ schema_cdm }}.{{ tgt_table_name }}
)
SELECT ROW_WID, TABLE_NAME
FROM max_row_wid_lookup
{% endmacro %}