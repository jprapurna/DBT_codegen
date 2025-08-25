{% macro null_default(column, default_value) %}
  COALESCE({{ column }}, {{ default_value }})
{% endmacro %}
