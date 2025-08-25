-- Purpose: Implement operational metrics
{{ config(materialized='table') }}
WITH metrics_data AS (
  SELECT
    Efficiency,
    Volume,
    Quality
  FROM {{ ref('int_filter_logic') }}
)
SELECT *
FROM metrics_data