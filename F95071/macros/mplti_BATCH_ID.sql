{% macro mplti_BATCH_ID(SOURCE_NAME) %}
WITH lkp_cdm_batch_ctrlid AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID, 
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('cdm', 'cdm_batch_ctrlid') }}
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
),
exp_null_check AS (
  SELECT 
    CASE 
      WHEN BATCH_ID IS NULL THEN -999 
      ELSE BATCH_ID 
    END AS o_BATCH_ID
  FROM lkp_cdm_batch_ctrlid
)
SELECT o_BATCH_ID
FROM exp_null_check
{% endmacro %}