{% macro generate_audit_ids(mapping_name, folder_name, workflow_name) %}
    SELECT 
        {{ dbt_utils.safe_cast(mapping_name, 'string') }} AS mapping_id,
        {{ dbt_utils.safe_cast(folder_name, 'string') }} AS folder_id,
        {{ dbt_utils.safe_cast(workflow_name, 'string') }} AS workflow_id
{% endmacro %}