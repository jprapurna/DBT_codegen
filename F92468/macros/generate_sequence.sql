{% macro generate_sequence(start_value=0, increment_by=1) %}
  {{ start_value }} + (row_number() over (order by null) - 1) * {{ increment_by }}
{% endmacro %}