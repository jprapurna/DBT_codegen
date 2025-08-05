-- Purpose: Update operation on W_CLAIM_CD_BUR_SCD3_U
WITH update_data AS (
  SELECT 
    * 
  FROM 
    {{ ref('int_UPD_BUR') }}
)
SELECT 
  * 
FROM 
  update_data