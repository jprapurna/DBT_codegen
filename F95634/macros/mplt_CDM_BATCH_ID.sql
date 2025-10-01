{% macro mplt_CDM_BATCH_ID(source_name) %}
WITH batch_id_lookup AS (
  SELECT
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = 'Running'
  GROUP BY SOURCE_NAME
)
SELECT
  BATCH_ID
FROM batch_id_lookup
WHERE SOURCE_NAME = {{ source_name }}
{% endmacro %}