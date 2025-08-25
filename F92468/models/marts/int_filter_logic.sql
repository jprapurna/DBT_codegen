-- Purpose: Apply filtering logic
WITH filtered_data AS (
  SELECT *
  FROM {{ ref('int_exp_bur') }}
  WHERE Date BETWEEN start_date AND end_date
    AND Status = 'Active'
    AND Region IN ('North', 'South', 'East', 'West')
)
SELECT *
FROM filtered_data