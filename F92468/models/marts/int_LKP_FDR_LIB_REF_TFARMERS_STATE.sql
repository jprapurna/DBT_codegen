-- Purpose: Lookup transformation to derive ST_ABBR using FARMERS_STATE_CD as input.

WITH state_abbr_lookup AS (
  SELECT
    FARMERS_STATE_CD,
    STATE_CODE
  FROM {{ source('FDR', 'REF_TFARMERS_STATE') }}
  WHERE FARMERS_STATE_CD = {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }}.i_FARMERS_STATE_CD
)

SELECT
  FARMERS_STATE_CD,
  STATE_CODE
FROM state_abbr_lookup