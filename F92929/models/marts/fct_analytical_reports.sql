-- Purpose: Feed Power BI, Tableau, and other BI platforms with performance datasets

WITH analytical_reports AS (
  SELECT
    a.customer_lifetime_value,
    b.aggregated_metric
  FROM {{ ref('int_custom_calculations') }} AS a
  JOIN {{ ref('int_aggregation') }} AS b ON a.key = b.key
)

SELECT
  customer_lifetime_value,
  aggregated_metric
FROM analytical_reports