-- Purpose: This model performs a lookup to derive ST_ABBR using FARMERS_STATE_CD as input.

WITH lookup AS (
  SELECT
    FARMERS_STATE_CD,
    STATE_CODE
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE FARMERS_STATE_CD = i_FARMERS_STATE_CD
)

SELECT
  i_FARMERS_STATE_CD AS FARMERS_STATE_CD,
  lookup.STATE_CODE
FROM lookup