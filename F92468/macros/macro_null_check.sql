{% macro macro_null_check(batch_id_column) %}
CASE WHEN {{ batch_id_column }} IS NULL THEN -999 ELSE {{ batch_id_column }} END
{% endmacro %}