{% macro macro_null_check(lkp_batch_id) %}
CASE 
  WHEN {{ lkp_batch_id }} IS NULL THEN -999 
  ELSE {{ lkp_batch_id }} 
END
{% endmacro %}