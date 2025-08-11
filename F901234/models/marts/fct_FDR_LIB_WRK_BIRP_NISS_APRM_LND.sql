-- Purpose: Used for loading data related to NISS_APRM_LND

WITH transformed_data AS (
  SELECT *
  FROM {{ ref('int_EXP_Passtotgt') }}
)

SELECT 
  transformed_data.*
FROM transformed_data