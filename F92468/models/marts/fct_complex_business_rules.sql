-- Purpose: Develop complex business rules
{{ config(materialized='table') }}
WITH rules_data AS (
  SELECT
    Advanced_Formula_1,
    Advanced_Formula_2
  FROM {{ ref('int_filter_logic') }}
)
SELECT *
FROM rules_data