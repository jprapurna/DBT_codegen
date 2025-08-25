{% macro hash_key(fields) %}
    {{ dbt_utils.hash(fields) }}
{% endmacro %}