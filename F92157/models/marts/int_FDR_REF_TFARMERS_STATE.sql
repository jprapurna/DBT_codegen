{{ config(materialized='table') }}
-- Source table for lookup operation to derive ST_ABBR.
SELECT DISTINCT
  R.FARMERS_STATE_CD AS FARMERS_STATE_CD,
  R.STATE_CODE AS STATE_CODE
FROM {{ source('FDR', 'REF_TFARMERS_STATE') }} R
WHERE R.END_EFF_DT = '2999-12-31'
ORDER BY FARMERS_STATE_CD
-- Keep this as last line to disable Informatica default orderby clause.