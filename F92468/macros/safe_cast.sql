{% macro safe_cast(column, data_type) %}
    TRY_CAST({{ column }} AS {{ data_type }})
{% endmacro %}