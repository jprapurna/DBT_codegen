-- Purpose: Represents the transformation logic from the expression transformation to the target table FDR_LIB_WRK_BIRP_NISS_APRM_LND

WITH source_data AS (
  SELECT *
  FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_TA_NISS_NU0C_APRM_LND') }}
)

SELECT 
  source_data.*
FROM source_data