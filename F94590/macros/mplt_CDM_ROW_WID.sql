{% macro mplt_CDM_ROW_WID(tgt_table_name) %}
WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS max_row_wid
  FROM {{ tgt_table_name }}
),
incremented_row_wid AS (
  SELECT 
    {{ increment_v1('max_row_wid') }} AS new_row_wid
  FROM max_row_wid
)
SELECT 
  new_row_wid AS ROW_WID
FROM incremented_row_wid
{% endmacro %}