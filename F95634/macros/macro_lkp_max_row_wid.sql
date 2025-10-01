{% macro macro_lkp_max_row_wid(target_table_name, v2) %}
  CASE 
    WHEN {{ v2 }} = 0 THEN (SELECT MAX(ROW_WID) FROM {{ target_table_name }})
    ELSE {{ v2 }}
  END
{% endmacro %}