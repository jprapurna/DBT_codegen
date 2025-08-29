{% macro null_default(value, default) %}
  NVL({{ value }}, {{ default }})
{% endmacro %}