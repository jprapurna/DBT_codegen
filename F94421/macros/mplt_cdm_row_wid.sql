{% macro mplt_cdm_row_wid(tgt_table_name) %}
WITH max_row_wid AS (
  SELECT 
    COALESCE(MAX(ROW_WID), 0) AS max_row_wid
  FROM {{ ref(tgt_table_name) }}
),
row_wid_calc AS (
  SELECT 
    max_row_wid + 1 AS new_row_wid
  FROM max_row_wid
)
SELECT new_row_wid
FROM row_wid_calc
{% endmacro %}