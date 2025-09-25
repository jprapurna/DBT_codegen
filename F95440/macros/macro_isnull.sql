{% macro macro_isnull(value) %}
CASE WHEN {{ value }} IS NULL THEN -999 ELSE {{ value }} END
{% endmacro %}