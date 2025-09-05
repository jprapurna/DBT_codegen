{% macro macro_max_row_wid(v2, TGT_TABLE_NAME) %}
CASE 
  WHEN v2 = 0 THEN (
    SELECT NVL(MAX(ROW_WID), 0) 
    FROM {{ source('custom_table', TGT_TABLE_NAME) }}
  )
  ELSE v2
END
{% endmacro %}