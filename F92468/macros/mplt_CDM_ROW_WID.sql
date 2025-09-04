{% macro mplt_CDM_ROW_WID(TGT_TABLE_NAME) %}
WITH lkp_max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '$$TGT_TABLE_NAME' AS TABLE_NAME
  FROM $$SCHEMA_CDM.$$TGT_TABLE_NAME
)
SELECT 
  CASE 
    WHEN V2 = 0 THEN lkp_max_row_wid.ROW_WID
    ELSE V2
  END AS ROW_WID
FROM lkp_max_row_wid
{% endmacro %}