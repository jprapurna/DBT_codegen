{% macro safe_cast(value, target_type) %}
    CASE
        WHEN {{ value }} IS NULL THEN NULL
        ELSE CAST({{ value }} AS {{ target_type }})
    END
{% endmacro %}