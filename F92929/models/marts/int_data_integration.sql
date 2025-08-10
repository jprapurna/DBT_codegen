-- Purpose: Consolidate datasets using Lookup, Joiner, and Union transformations

WITH data_integration AS (
  SELECT
    a.field1 AS integrated_field1,
    b.field2 AS integrated_field2
  FROM {{ ref('int_data_quality') }} AS a
  JOIN {{ ref('int_cloud_storage_data') }} AS b ON a.key = b.key
)

SELECT
  integrated_field1,
  integrated_field2
FROM data_integration