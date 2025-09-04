{% macro macro_increment_v1(v1) %}
SELECT {{ v1 }} + 1 AS incremented_v1
{% endmacro %}