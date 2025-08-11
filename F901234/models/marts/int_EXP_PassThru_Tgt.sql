-- Purpose: Represents the transformation logic from the expression transformation to the target table WRK_BIRP_NISS_APRM_DETL

WITH passthru_data AS (
  SELECT *
  FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_TA_NISS_NU0C_APRM_DTL') }}
)

SELECT 
  passthru_data.*
FROM passthru_data