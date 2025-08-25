{% macro generate_row_wid(table_name) %}
SELECT 
    CASE 
        WHEN MAX(row_wid) IS NULL THEN 1
        ELSE MAX(row_wid) + 1
    END AS row_wid
FROM {{ table_name }}
{% endmacro %}