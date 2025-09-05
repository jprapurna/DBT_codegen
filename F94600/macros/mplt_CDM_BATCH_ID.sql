{% macro mplt_CDM_BATCH_ID(SOURCE_NAME) %}
WITH processed_data AS (
  SELECT
    SOURCE_NAME,
    -- Transformation logic for batch ID
    CASE 
      WHEN SOURCE_NAME IS NULL THEN -999
      ELSE SOURCE_NAME
    END AS o_BATCH_ID
  FROM {{ SOURCE_NAME }}
)
SELECT o_BATCH_ID
FROM processed_data
{% endmacro %}