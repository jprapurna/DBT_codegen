{% macro generate_row_wid(tgt_table_name) %}
SELECT 
    NVL(MAX(ROW_WID), 0) + 1 AS ROW_WID
FROM 
    {{ tgt_table_name }}
{% endmacro %}