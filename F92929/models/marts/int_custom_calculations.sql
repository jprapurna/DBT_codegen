-- Purpose: Implement advanced calculations using Java and Python transformations

WITH custom_calculations AS (
  SELECT
    field1,
    field2,
    java_transformation(field1, field2) AS customer_lifetime_value,
    python_transformation(field1, field2) AS profitability_ratio
  FROM {{ ref('int_data_integration') }}
)

SELECT
  field1,
  field2,
  customer_lifetime_value,
  profitability_ratio
FROM custom_calculations