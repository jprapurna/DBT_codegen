{% macro decode_logic(field, mapping_dict) %}
    CASE
        {% for key, value in mapping_dict.items() %}
        WHEN {{ field }} = '{{ key }}' THEN '{{ value }}'
        {% endfor %}
        ELSE NULL
    END
{% endmacro %}