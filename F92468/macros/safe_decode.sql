{% macro safe_decode(input_field) %}
    CASE 
        WHEN {{ input_field }} IS NULL OR {{ input_field }} = '' THEN 'UNKNOWN'
        ELSE {{ input_field }}
    END
{% endmacro %}