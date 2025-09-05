{% macro macro_max_row_wid(v2, TGT_TABLE_NAME) %}
CASE 
  WHEN v2 = 0 THEN (SELECT ROW_WID FROM {{ ref('int_cdm__max_row_wid') }} WHERE TABLE_NAME = TGT_TABLE_NAME)
  ELSE v2
END
{% endmacro %}