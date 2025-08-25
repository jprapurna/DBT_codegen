-- Purpose: Map POLICY_STATE to INTEGRATION_ID
WITH mapped_data AS (
  SELECT
    ROW_WID,
    IIF(V2 = 0, {{ ref('int_lkp_max_row_wid') }}.ROW_WID, V2) AS ROW_WID,
    V1 + 1 AS V2
  FROM {{ ref('int_cdh_gw_bur') }}
)
SELECT *
FROM mapped_data