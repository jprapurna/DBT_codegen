{% macro macro_lookup_max_row_wid(table_name) %}
SELECT 
  COALESCE(MAX(ROW_WID), 0) AS ROW_WID, 
  {{ table_name }} AS table_name
FROM schema.table_name
{% endmacro %}