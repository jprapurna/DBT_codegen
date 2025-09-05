{% macro macro_flag_logic(LKP_ROW_WID, BUR, LKP_NEW_BUR) %}
CASE 
  WHEN LKP_ROW_WID IS NULL THEN 'I'
  WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
  ELSE 'U'
END
{% endmacro %}