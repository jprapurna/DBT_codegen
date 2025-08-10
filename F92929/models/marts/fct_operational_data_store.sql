-- Purpose: Deliver cleansed datasets to operational systems via REST APIs or flat-file exports

WITH operational_data_store AS (
  SELECT
    a.normalized_field1,
    b.integrated_field1,
    c.customer_lifetime_value
  FROM {{ ref('int_data_cleansing') }} AS a
  JOIN {{ ref('int_data_integration') }} AS b ON a.key = b.key
  JOIN {{ ref('int_custom_calculations') }} AS c ON a.key = c.key
)

SELECT
  normalized_field1,
  integrated_field1,
  customer_lifetime_value
FROM operational_data_store