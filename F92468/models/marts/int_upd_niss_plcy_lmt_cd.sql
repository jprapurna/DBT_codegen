-- Purpose: Intermediate model for update strategy logic for fields NISS_APRM_DETL_SK and NISS_PLCY_LMT_CD

WITH base_data AS (
  SELECT
    NISS_APRM_DETL_SK,
    NISS_PLCY_LMT_CD
  FROM {{ source('WRK_BIRP_NISS_APRM_DETL', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
  NISS_APRM_DETL_SK,
  NISS_PLCY_LMT_CD
FROM base_data
{% if is_incremental() %}
WHERE operation_dt > (SELECT MAX(operation_dt) FROM {{ this }})
{% endif %}