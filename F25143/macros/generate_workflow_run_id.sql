{% macro generate_workflow_run_id(mapping_name, folder_name, workflow_name) %}
    {{ dbt_utils.surrogate_key([
        mapping_name,
        folder_name,
        workflow_name
    ]) }}
{% endmacro %}