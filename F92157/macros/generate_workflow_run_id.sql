{% macro generate_workflow_run_id(workflow_name) %}
    CASE
        WHEN {{ workflow_name }} IS NULL THEN 'UNKNOWN'
        ELSE {{ workflow_name }}
    END
{% endmacro %}
