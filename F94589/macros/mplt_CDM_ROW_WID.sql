{% macro mplt_CDM_ROW_WID(batch_ctrlid) %}
WITH exp_NULL_CHECK AS (
  SELECT
    *,
    {% if batch_ctrlid is not none %}
      {{ isnull(batch_ctrlid, 0) }} AS batch_ctrlid_checked
    {% else %}
      NULL AS batch_ctrlid_checked
    {% endif %}
  FROM {{ batch_ctrlid }}
),
exp_ROW_WID AS (
  SELECT
    *,
    {{ increment_v1('ROW_WID') }} AS new_row_wid
  FROM exp_NULL_CHECK
)
SELECT
  new_row_wid
FROM exp_ROW_WID
{% endmacro %}