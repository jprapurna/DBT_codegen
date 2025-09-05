{% macro mplt_cdm_batch_id(source_name, status_running) %}
WITH filtered_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = {{ status_running }}
  GROUP BY SOURCE_NAME
)
SELECT * FROM filtered_data
{% endmacro %}