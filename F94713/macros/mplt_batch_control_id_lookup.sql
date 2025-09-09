{% macro mplt_batch_control_id_lookup(batch_id) %}
WITH batch_control_id_lookup AS (
  SELECT
    lkp_batch_ctrl.batch_ctrl_id AS batch_ctrl_id
  FROM {{ source('lkp_CDM_BATCH_CTRLID', 'lkp_CDM_BATCH_CTRLID') }} AS lkp_batch_ctrl
  WHERE lkp_batch_ctrl.batch_id = {{ batch_id }}
)
SELECT batch_ctrl_id
FROM batch_control_id_lookup
{% endmacro %}