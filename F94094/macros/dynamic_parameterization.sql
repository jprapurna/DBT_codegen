{% macro dynamic_parameterization(schema_name, source_name) %}
  {{ schema_name }}.{{ source_name }}
{% endmacro %}