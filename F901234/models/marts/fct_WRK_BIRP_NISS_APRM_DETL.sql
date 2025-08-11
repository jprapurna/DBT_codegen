-- Purpose: Used to load detailed information related to NISS APRM

WITH detailed_data AS (
  SELECT *
  FROM {{ ref('int_EXP_PassThru_Tgt') }}
)

SELECT 
  detailed_data.*
FROM detailed_data