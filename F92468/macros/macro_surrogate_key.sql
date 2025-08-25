{% macro surrogate_key(fields) %}
dbt_utils.surrogate_key({{ fields | join(', ') }})
{% endmacro %}