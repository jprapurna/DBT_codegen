-- Purpose: Implement financial KPIs
{{ config(materialized='table') }}
WITH kpi_data AS (
  SELECT
    Revenue,
    Profit,
    (Profit / Revenue) * 100 AS ROI
  FROM {{ ref('int_filter_logic') }}
)
SELECT *
FROM kpi_data