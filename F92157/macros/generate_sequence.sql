{% macro generate_sequence(start_value=0, increment_by=1) %}
    {% set sequence = [] %}
    {% for i in range(start_value, start_value + increment_by * 100) %}
        {{ sequence.append(i) }}
    {% endfor %}
    {{ return(sequence) }}
{% endmacro %}
