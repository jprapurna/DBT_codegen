-- Purpose: Route data based on the value of `o_Flag`

WITH routed_data AS (
  SELECT 
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT
  FROM {{ ref('int_exp_flag') }}
)

SELECT 
  o_Flag,
  CDM_INSERT_DT,
  CDM_UPDATE_DT
FROM routed_data