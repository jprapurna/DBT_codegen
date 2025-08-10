-- Purpose: Apply cleansing and standardization transformations

WITH data_cleansing AS (
  SELECT
    field1,
    field2,
    COALESCE(expression_transformation(field1), 'default_value') AS normalized_field1,
    COALESCE(expression_transformation(field2), 'default_value') AS normalized_field2
  FROM {{ ref('int_cloud_application_data') }}
)

SELECT
  field1,
  field2,
  normalized_field1,
  normalized_field2
FROM data_cleansing