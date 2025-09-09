{% macro mplt_flag_logic(o_flag) %}
CASE 
  WHEN {{ o_flag }} = 'I' THEN 'INSERT'
  WHEN {{ o_flag }} = 'U' THEN 'UPDATE'
  ELSE 'NO_CHANGE'
END AS operation_flag
{% endmacro %}