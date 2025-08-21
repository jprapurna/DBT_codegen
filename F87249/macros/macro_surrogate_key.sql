{% macro macro_surrogate_key(fields) %}
{{ dbt_utils.surrogate_key(fields) }}
{% endmacro %}