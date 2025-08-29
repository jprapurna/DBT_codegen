{% macro safe_cast(value, type) %}
  {{ dbt_utils.safe_cast(value, type) }}
{% endmacro %}