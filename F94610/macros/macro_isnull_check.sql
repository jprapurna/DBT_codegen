{% macro macro_isnull_check(LKP_BATCH_ID) %}
CASE 
  WHEN LKP_BATCH_ID IS NULL THEN -999
  ELSE LKP_BATCH_ID
END
{% endmacro %}