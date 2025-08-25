{% macro safe_cast_to_integer(value) %}
    CASE
        WHEN {{ value }} IS NULL THEN NULL
        WHEN {{ value }} RLIKE '^\d+$' THEN CAST({{ value }} AS INTEGER)
        ELSE NULL
    END
{% endmacro %}
