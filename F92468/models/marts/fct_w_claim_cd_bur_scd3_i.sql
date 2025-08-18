-- Purpose: Insert data into the target table `W_CLAIM_CD_BUR_SCD3`

WITH insert_data AS (
  SELECT 
    *
  FROM {{ ref('int_rtr_clm_insert_upd') }}
  WHERE o_Flag = 'I'
)

SELECT 
  *
FROM insert_data