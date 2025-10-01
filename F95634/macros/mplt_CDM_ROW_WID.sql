{% macro mplt_CDM_ROW_WID(table_name) %}
WITH max_row_wid_lookup AS (
  SELECT
    COALESCE(MAX(ROW_WID), 0) AS ROW_WID,
    {{ table_name }} AS TABLE_NAME
  FROM {{ ref('int_cdm__row_wid') }}
)
SELECT
  ROW_WID
FROM max_row_wid_lookup
WHERE TABLE_NAME = {{ table_name }}
{% endmacro %}