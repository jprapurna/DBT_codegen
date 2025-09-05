{% macro mplt_CDM_ROW_WID(TGT_TABLE_NAME) %}
WITH lkp_MAX_ROW_WID AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ TGT_TABLE_NAME }}' AS TABLE_NAME
  FROM {{ source('cdm', TGT_TABLE_NAME) }}
),
exp_ROW_WID AS (
  SELECT 
    CASE 
      WHEN v2 = 0 THEN ROW_WID
      ELSE v2
    END AS ROW_WID
  FROM lkp_MAX_ROW_WID
)
SELECT ROW_WID
FROM exp_ROW_WID
{% endmacro %}