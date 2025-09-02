{{
  config(materialized='table')
}}

WITH business_kpis AS (
  SELECT
    Revenue,
    Profit,
    ROI,
    macro_business_kpis(Revenue, Profit, ROI) AS Calculated_KPIs
  FROM {{ source('schema_cdm', 'financial_kpis') }}
),

operational_metrics AS (
  SELECT
    Efficiency,
    Volume,
    Quality,
    macro_business_kpis(Efficiency, Volume, Quality) AS Calculated_Metrics
  FROM {{ source('schema_cdm', 'operational_metrics') }}
),

final_data AS (
  SELECT
    *,
    Calculated_KPIs,
    Calculated_Metrics
  FROM business_kpis
  JOIN operational_metrics ON business_kpis.Revenue = operational_metrics.Efficiency
)

SELECT *
FROM final_data