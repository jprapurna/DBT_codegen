{% macro split_string_parts(input_string, delimiter, part_number) %}
    split_part({{ input_string }}, {{ delimiter }}, {{ part_number }})
{% endmacro %}