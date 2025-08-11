-- Purpose: Represents the update logic for NISS_CLASS_CD in the target table FDR_LIB_WRK_BIRP_NISS_APRM_DETL1

WITH update_data AS (
  SELECT *
  FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT 
  update_data.*
FROM update_data