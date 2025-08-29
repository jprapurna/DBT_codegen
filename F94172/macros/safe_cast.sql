{% macro safe_cast(value, target_type) %}
    {{ dbt_utils.safe_cast(value, target_type) }}
{% endmacro %}