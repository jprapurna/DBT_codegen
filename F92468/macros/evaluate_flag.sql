{% macro evaluate_flag(bur, lkp_new_bur, lkp_row_wid) %}
CASE 
  WHEN {{ lkp_row_wid }} IS NULL THEN 'I'
  WHEN {{ bur }} != {{ lkp_new_bur }} THEN 'U'
  ELSE 'NC'
END
{% endmacro %}