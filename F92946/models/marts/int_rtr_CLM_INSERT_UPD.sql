-- Purpose: Generates detailed session logs for auditing and troubleshooting purposes.
WITH rtr_clm_insert_upd AS (
  SELECT 
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT,
    TGT_TABLE_NAME,
    CASE WHEN o_Flag = 'I' THEN 'INSERT' WHEN o_Flag = 'U' THEN 'UPDATE' END AS operation
  FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
  o_Flag,
  CDM_INSERT_DT,
  CDM_UPDATE_DT,
  TGT_TABLE_NAME,
  operation
FROM rtr_clm_insert_upd