{% macro split_limit_parts(input_string, delimiter) %}
    {% set parts = input_string.split(delimiter) %}
    {% set decimals = [] %}
    {% for part in parts %}
        {% set decimal_part = dbt_utils.safe_cast(part, 'decimal') %}
        {% do decimals.append(decimal_part) %}
    {% endfor %}
    {{ decimals }}
{% endmacro %}