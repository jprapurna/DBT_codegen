{% macro macro_null_check(field) %}
CASE 
  WHEN {{ field }} IS NULL THEN -999
  ELSE {{ field }}
END
{% endmacro %}