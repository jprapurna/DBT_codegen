{% macro generate_row_id(tgt_table_name, schema_cdm) %}
SELECT 
  MAX(ROW_WID) + 1 AS new_row_id
FROM {{ schema_cdm }}.{{ tgt_table_name }}
{% endmacro %}