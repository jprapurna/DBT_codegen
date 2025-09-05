{% macro macro_flag_logic(lkp_row_wid, bur, lkp_new_bur) %}
CASE 
  WHEN {{ lkp_row_wid }} IS NULL THEN 'I'
  WHEN MD5({{ bur }}) = MD5({{ lkp_new_bur }}) THEN 'NC'
  ELSE 'U'
END
{% endmacro %}