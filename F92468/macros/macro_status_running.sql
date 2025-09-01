{% macro macro_status_running(status_column) %}
CASE WHEN {{ status_column }} = 'RUNNING' THEN TRUE ELSE FALSE END
{% endmacro %}