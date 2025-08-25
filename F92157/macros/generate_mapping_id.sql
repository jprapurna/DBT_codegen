{% macro generate_mapping_id(mapping_name, folder_name) %}
    CASE
        WHEN {{ mapping_name }} IS NULL THEN 'UNKNOWN'
        ELSE {{ mapping_name }}
    END || '_' || {{ folder_name }}
{% endmacro %}
