{% macro decode_logic(input_field, decode_map) %}
    CASE
        {% for key, value in decode_map.items() %}
        WHEN {{ input_field }} = '{{ key }}' THEN '{{ value }}'
        {% endfor %}
        ELSE NULL
    END
{% endmacro %}