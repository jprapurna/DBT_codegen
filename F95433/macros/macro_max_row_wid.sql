{% macro macro_max_row_wid(tgt_table_name) %}
SELECT 
  NVL(MAX(ROW_WID), 0) AS ROW_WID, 
  '{{ tgt_table_name }}' AS TABLE_NAME
FROM {{ ref(tgt_table_name) }}
{% endmacro %}