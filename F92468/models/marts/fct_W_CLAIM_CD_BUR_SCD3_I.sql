-- Purpose: Insert operation on W_CLAIM_CD_BUR_SCD3_I
WITH insert_data AS (
  SELECT 
    * 
  FROM 
    {{ ref('int_mplt_CDM_ROW_WID') }},
    {{ ref('int_rtr_CLM_INSERT_UPD') }}
)
SELECT 
  * 
FROM 
  insert_data