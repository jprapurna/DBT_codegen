{% macro macro_null_check(batch_id) %}
CASE
  WHEN {{ batch_id }} IS NULL THEN -999
  ELSE {{ batch_id }}
END
{% endmacro %}