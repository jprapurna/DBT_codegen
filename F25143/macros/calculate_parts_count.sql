{% macro calculate_parts_count(input_string, delimiter) %}
    {{ input_string.split(delimiter) | length }}
{% endmacro %}