{% macro macro_null_check(batch_id) %}
SELECT 
  CASE 
    WHEN {{ batch_id }} IS NULL THEN -999
    ELSE {{ batch_id }}
  END AS batch_id_checked
{% endmacro %}