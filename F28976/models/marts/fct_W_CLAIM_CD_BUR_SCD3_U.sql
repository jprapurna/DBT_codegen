-- Purpose: Update operation on the table W_CLAIM_CD_BUR_SCD3_U
WITH update_operation AS (
  SELECT 
    * 
  FROM {{ ref('int_UPD_BUR') }}
)
SELECT 
  * 
FROM update_operation