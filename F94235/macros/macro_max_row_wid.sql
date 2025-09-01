{% macro macro_max_row_wid(table_name) %}
SELECT NVL(MAX(ROW_WID), 0) AS ROW_WID
FROM {{ table_name }}
{% endmacro %}