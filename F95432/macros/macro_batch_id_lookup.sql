{% macro macro_batch_id_lookup(status_running) %}
SELECT 
  MAX(BATCH_ID) AS BATCH_ID, 
  TRIM(SOURCE_NAME) AS SOURCE_NAME 
FROM {{ source('cdm', 'cdm_batch_ctrlid') }} 
WHERE STATUS = {{ status_running }}
GROUP BY SOURCE_NAME
{% endmacro %}