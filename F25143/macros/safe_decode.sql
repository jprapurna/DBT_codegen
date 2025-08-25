{% macro safe_decode(input_field, default_value) %}
    CASE
        WHEN {{ input_field }} IS NULL OR {{ input_field }} = '' THEN {{ default_value }}
        ELSE {{ input_field }}
    END
{% endmacro %}