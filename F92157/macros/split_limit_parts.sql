{% macro split_limit_parts(input_string, delimiter, num_parts) %}
    {% set parts = input_string.split(delimiter) %}
    {% for i in range(0, num_parts) %}
        {% if i < parts|length %}
            {{ dbt_utils.safe_cast(parts[i], 'decimal') }}
        {% else %}
            NULL
        {% endif %}
    {% endfor %}
{% endmacro %}
