{% macro safe_null_check(field, default_value) %}
    CASE 
        WHEN {{ field }} IS NULL THEN {{ default_value }}
        ELSE {{ field }}
    END
{% endmacro %}