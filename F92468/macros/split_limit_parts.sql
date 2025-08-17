{% macro split_limit_parts(input_string, delimiter='/') %}
  {% set parts = input_string.split(delimiter) %}
  {% set part1 = dbt_utils.safe_cast(parts[0] if parts|length > 0 else '0', 'decimal') %}
  {% set part2 = dbt_utils.safe_cast(parts[1] if parts|length > 1 else '0', 'decimal') %}
  {% set part3 = dbt_utils.safe_cast(parts[2] if parts|length > 2 else '0', 'decimal') %}
  {% set num_parts = parts|length %}
  {{ return({'part1': part1, 'part2': part2, 'part3': part3, 'num_parts': num_parts}) }}
{% endmacro %}