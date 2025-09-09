{% macro mplt_flag_logic(integration_id, bur, lkp_new_bur, lkp_row_wid) %}
SELECT 
  CASE 
    WHEN lkp_row_wid IS NULL THEN 'I'
    WHEN MD5(bur) = MD5(lkp_new_bur) THEN 'NC'
    ELSE 'U'
  END AS o_Flag
{% endmacro %}