{% macro isnull(value, default) %}
CASE WHEN {{ value }} IS NULL THEN {{ default }} ELSE {{ value }} END
{% endmacro %}