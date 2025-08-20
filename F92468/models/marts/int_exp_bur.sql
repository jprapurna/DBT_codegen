-- Purpose: Maps POLICY_STATE to INTEGRATION_ID

WITH mapped_data AS (
  SELECT 
    POLICY_STATE AS integration_id
  FROM {{ ref('int_cdh_gw_bur') }}
)

SELECT 
  integration_id
FROM mapped_data