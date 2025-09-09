{% macro mplt_cdm_row_wid(tgt_table_name) %}
WITH step1 AS (
  SELECT 
    ROW_WID
  FROM {{ macro_lkp_max_row_wid(tgt_table_name) }}
)
SELECT ROW_WID
FROM step1
{% endmacro %}