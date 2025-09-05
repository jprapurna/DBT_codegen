{% macro macro_max_row_wid(schema, table) %}
SELECT NVL(MAX(ROW_WID), 0) AS ROW_WID, '{{ table }}' AS TABLE_NAME
FROM {{ schema }}.{{ table }}
{% endmacro %}