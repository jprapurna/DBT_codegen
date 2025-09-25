{% macro mplt_batch_id(lkp_batch_id) %}
WITH null_check AS (
  SELECT
    CASE 
      WHEN {{ lkp_batch_id }} IS NULL THEN -999
      ELSE {{ lkp_batch_id }}
    END AS o_BATCH_ID
)
SELECT o_BATCH_ID
FROM null_check
{% endmacro %}