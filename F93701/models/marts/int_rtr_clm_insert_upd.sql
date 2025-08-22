-- Purpose: Routes data based on the operation flag (INSERT or UPDATE).
WITH routed_data AS (
  SELECT 
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT,
    TGT_TABLE_NAME
  FROM {{ ref('int_exp_flag') }}
  WHERE o_Flag IN ('I', 'U')
)
SELECT * FROM routed_data