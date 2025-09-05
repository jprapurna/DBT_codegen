{% macro mplt_CDM_ROW_WID(TGT_TABLE_NAME) %}
WITH lkp_max_row_wid AS (
  SELECT 
    COALESCE(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ TGT_TABLE_NAME }}' AS TABLE_NAME
  FROM {{ ref('int_cdm_row_wid') }}
),
exp_row_wid AS (
  SELECT 
    CASE 
      WHEN v2 = 0 THEN (SELECT ROW_WID FROM lkp_max_row_wid)
      ELSE v2
    END AS ROW_WID,
    v1 + 1 AS v2
  FROM lkp_max_row_wid
)
SELECT ROW_WID
FROM exp_row_wid
{% endmacro %}