{% macro macro_status_running(source_name) %}
WITH filtered_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID, 
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = {{ var('STATUS_RUNNING') }}
  GROUP BY SOURCE_NAME
)
SELECT BATCH_ID, SOURCE_NAME
FROM filtered_data
{% endmacro %}