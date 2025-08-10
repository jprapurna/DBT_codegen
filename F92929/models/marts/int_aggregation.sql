-- Purpose: Compute summaries by region, product line, and time period

WITH aggregation AS (
  SELECT
    region,
    product_line,
    time_period,
    SUM(metric) AS aggregated_metric
  FROM {{ ref('int_custom_calculations') }}
  GROUP BY region, product_line, time_period
)

SELECT
  region,
  product_line,
  time_period,
  aggregated_metric
FROM aggregation