-- Purpose: Route exceptions to audit tables or notification services

WITH error_handling AS (
  SELECT
    field1,
    field2,
    CASE WHEN error_condition(field1) THEN 'error' ELSE 'ok' END AS error_status
  FROM {{ ref('int_aggregation') }}
)

SELECT
  field1,
  field2,
  error_status
FROM error_handling