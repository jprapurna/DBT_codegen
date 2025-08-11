-- Purpose: Intermediate model for update strategy logic for fields NISS_APRM_DETL_SK and NISS_PLCY_LMT_CD

WITH update_strategy AS (
  SELECT
    NISS_APRM_DETL_SK,
    NISS_PLCY_LMT_CD,
    'DD_UPDATE' AS update_strategy_expression,
    'YES' AS forward_rejected_rows
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
  NISS_APRM_DETL_SK,
  NISS_PLCY_LMT_CD
FROM update_strategy