{% macro macro_max_row_wid(schema_cdm, tgt_table_name) %}
SELECT 
    COALESCE(MAX(ROW_WID), 0) AS ROW_WID
FROM {{ schema_cdm }}.{{ tgt_table_name }}
{% endmacro %}