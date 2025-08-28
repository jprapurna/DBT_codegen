{% macro surrogate_key(columns) %}
    dbt_utils.surrogate_key({{ columns }})
{% endmacro %}