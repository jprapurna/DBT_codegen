{% macro generate_surrogate_key(columns) %}
    dbt_utils.surrogate_key({{ columns | join(', ') }})
{% endmacro %}