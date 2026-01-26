{% macro macro_flag_logic(lkp_row_wid, bur, lkp_new_bur) %}
SELECT 
  CASE 
    WHEN {{ lkp_row_wid }} IS NULL THEN 'I'
    WHEN MD5({{ bur }}) = MD5({{ lkp_new_bur }}) THEN 'NC'
    ELSE 'U'
  END AS flag
{% endmacro %}