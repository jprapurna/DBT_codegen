{% macro mplt_CDM_ROW_WID(TGT_TABLE_NAME) %}
WITH lkp_max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ TGT_TABLE_NAME }}' AS TABLE_NAME
  FROM {{ source('SCHEMA_CDM', TGT_TABLE_NAME) }}
)
SELECT ROW_WID, TABLE_NAME
FROM lkp_max_row_wid
{% endmacro %}