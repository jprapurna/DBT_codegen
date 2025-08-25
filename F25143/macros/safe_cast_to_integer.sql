{% macro safe_cast_to_integer(field) %}
    CASE
        WHEN {{ field }} IS NULL THEN NULL
        ELSE CAST({{ field }} AS INTEGER)
    END
{% endmacro %}