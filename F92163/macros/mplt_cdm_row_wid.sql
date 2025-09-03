{% macro mplt_cdm_row_wid(tgt_table_name) %}
WITH lkp_max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ tgt_table_name }}' AS TABLE_NAME
  FROM {{ source('custom_table', 'max_row_wid') }}
  WHERE TABLE_NAME = '{{ tgt_table_name }}'
),
exp_row_wid AS (
  SELECT 
    CASE 
      WHEN ROW_WID = 0 THEN ROW_WID + 1
      ELSE ROW_WID
    END AS ROW_WID
  FROM lkp_max_row_wid
)
SELECT ROW_WID
FROM exp_row_wid
{% endmacro %}