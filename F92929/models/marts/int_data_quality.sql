-- Purpose: Implement Data Quality rules and Constraint transformations

WITH data_quality AS (
  SELECT
    field1,
    field2
  FROM {{ ref('int_data_cleansing') }}
  WHERE data_quality_check(field1) AND data_quality_check(field2)
)

SELECT
  field1,
  field2
FROM data_quality