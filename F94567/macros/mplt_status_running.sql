{% macro mplt_status_running(status_column) %}
SELECT *
FROM {{ this }}
WHERE {{ status_column }} = 'RUNNING'
{% endmacro %}