-- Purpose: Used for updating NISS_CLASS_CD

WITH updated_data AS (
  SELECT *
  FROM {{ ref('int_UPD_NISS_CLASS_CD') }}
)

SELECT 
  updated_data.*
FROM updated_data