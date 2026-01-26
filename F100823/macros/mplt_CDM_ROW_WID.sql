{% macro mplt_CDM_ROW_WID(tgt_table_name) %}
WITH max_row_wid_lookup AS (
  SELECT 
    MAX(ROW_WID) AS max_row_wid
  FROM {{ source('custom_table', tgt_table_name) }}
),
row_wid_calculation AS (
  SELECT 
    CASE 
      WHEN max_row_wid IS NULL THEN 1
      ELSE max_row_wid + 1
    END AS row_wid
  FROM max_row_wid_lookup
)
SELECT row_wid
FROM row_wid_calculation
{% endmacro %}