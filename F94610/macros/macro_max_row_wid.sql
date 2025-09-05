{% macro macro_max_row_wid(v2, TGT_TABLE_NAME) %}
CASE 
  WHEN v2 = 0 THEN { mplt_CDM_ROW_WID(TGT_TABLE_NAME) }
  ELSE v2
END
{% endmacro %}