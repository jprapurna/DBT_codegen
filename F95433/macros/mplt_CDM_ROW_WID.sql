{% macro mplt_CDM_ROW_WID(target_table_name) %}
WITH lkp_MAX_ROW_WID AS (
  SELECT 
    COALESCE(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ target_table_name }}' AS TABLE_NAME
  FROM {{ source('CDM', target_table_name) }}
),
exp_ROW_WID AS (
  SELECT
    ROW_WID + 1 AS ROW_WID
  FROM lkp_MAX_ROW_WID
)
SELECT 
  ROW_WID
FROM exp_ROW_WID
{% endmacro %}