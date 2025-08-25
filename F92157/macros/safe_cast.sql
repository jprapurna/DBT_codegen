{% macro safe_cast(column, type) %}
  {{ dbt_utils.safe_cast(column, type) }}
{% endmacro %}
