-- Purpose: Update data in the target table `W_CLAIM_CD_BUR_SCD3`

WITH update_data AS (
  SELECT 
    *
  FROM {{ ref('int_upd_bur') }}
  WHERE o_Flag = 'U'
)

SELECT 
  *
FROM update_data