{% macro mplt_CDM_ROW_WID(TGT_TABLE_NAME) %}
WITH lkp_max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ TGT_TABLE_NAME }}' AS TABLE_NAME
  FROM {{ source('cdm', 'custom_table') }}
),
exp_row_wid AS (
  SELECT 
    ROW_WID + 1 AS ROW_WID
  FROM lkp_max_row_wid
)
SELECT ROW_WID
FROM exp_row_wid
{% endmacro %}