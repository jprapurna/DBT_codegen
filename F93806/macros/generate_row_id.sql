{% macro generate_row_id(target_table) %}
SELECT COALESCE(MAX(ROW_WID), 0) + 1 AS ROW_WID
FROM {{ target_table }}
{% endmacro %}