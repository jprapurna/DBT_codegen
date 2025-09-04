{% macro mplt_cdm_row_wid(tgt_table_name) %}
WITH variable_binding AS (
  SELECT
    ROW_WID AS row_wid
  FROM {{ source('custom_table', 'custom_table') }}
  WHERE TABLE_NAME = {{ tgt_table_name }}
)
SELECT row_wid
FROM variable_binding
{% endmacro %}