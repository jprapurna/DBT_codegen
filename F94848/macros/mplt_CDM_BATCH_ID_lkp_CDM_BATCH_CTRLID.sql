{% macro mplt_CDM_BATCH_ID_lkp_CDM_BATCH_CTRLID(status_running, source_name) %}
WITH batch_ctrlid_lookup AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID,
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'dummy_mplt_cdm_batch_id_lkp_cdm_batch_ctrlid') }}
  WHERE STATUS = {{ status_running }}
  GROUP BY SOURCE_NAME
)
SELECT BATCH_ID, SOURCE_NAME
FROM batch_ctrlid_lookup
{% endmacro %}