{% macro mplt_CDM_BATCH_ID(batch_id) %}
WITH batch_data AS (
  SELECT
    *,
    CASE 
      WHEN ISNULL(batch_id) THEN 'UNKNOWN'
      ELSE batch_id
    END AS processed_batch_id
  FROM {{ source('schema_cdm', 'cdm_batch_ctrlid') }}
)
SELECT processed_batch_id
FROM batch_data
{% endmacro %}