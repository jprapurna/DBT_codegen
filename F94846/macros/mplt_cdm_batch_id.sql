{% macro mplt_cdm_batch_id(source_name) %}
WITH batch_lookup AS (
  SELECT
    BATCH_ID,
    SOURCE_NAME
  FROM {{ source('cdm_batch_ctrlid') }}
  WHERE SOURCE_NAME = {{ source_name }}
)
SELECT
  BATCH_ID
FROM batch_lookup
{% endmacro %}