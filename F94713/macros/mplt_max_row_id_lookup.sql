{% macro mplt_max_row_id_lookup(row_id) %}
WITH max_row_id_lookup AS (
  SELECT
    lkp_max_row.row_id AS max_row_id
  FROM {{ source('lkp_MAX_ROW_WID', 'lkp_MAX_ROW_WID') }} AS lkp_max_row
  WHERE lkp_max_row.row_id = {{ row_id }}
)
SELECT max_row_id
FROM max_row_id_lookup
{% endmacro %}