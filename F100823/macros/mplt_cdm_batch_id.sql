{% macro mplt_cdm_batch_id(source_name) %}
WITH batch_data AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
)
SELECT BATCH_ID, SOURCE_NAME
FROM batch_data
{% endmacro %}

---