-- Purpose: Implement Router Logic
WITH router_data AS (
  SELECT
    CASE
      WHEN o_Flag = 'I' THEN 'INSERT'
      WHEN o_Flag = 'U' THEN 'UPDATE'
      ELSE 'OTHER'
    END AS route_action
  FROM {{ ref('int_exp_bur') }}
)
SELECT *
FROM router_data