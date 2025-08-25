{% macro generate_sequence(start_value, increment_by) %}
    {% set sequence = [] %}
    {% for i in range(0, 1000) %}
        {% set value = start_value + (i * increment_by) %}
        {% do sequence.append(value) %}
    {% endfor %}
    {{ sequence }}
{% endmacro %}