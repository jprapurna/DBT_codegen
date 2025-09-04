{% macro mplt_CDM_BATCH_ID(in_SOURCE_NAME) %}
WITH batch_lookup AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('DBA_COMMON_UTILS', 'LKP_CDM_BATCH_CTRLID') }}
  WHERE STATUS = {{ var('status_running') }}
  GROUP BY SOURCE_NAME
)
SELECT 
  BATCH_ID,
  SOURCE_NAME
FROM batch_lookup
{% endmacro %}