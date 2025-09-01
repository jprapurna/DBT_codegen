{% macro macro_flag_logic(INTEGRATION_ID, LKP_ROW_WID, LKP_NEW_BUR, BUR) %}
SELECT 
  CASE 
    WHEN ISNULL(LKP_ROW_WID) THEN 'I'
    WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
    ELSE 'U'
  END AS o_Flag
{% endmacro %}