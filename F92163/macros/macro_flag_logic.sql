{% macro macro_flag_logic(integration_id) %}
SELECT 
  CASE 
    WHEN {{ integration_id }} IS NULL THEN 'I'
    ELSE 'U'
  END AS flag
{% endmacro %}