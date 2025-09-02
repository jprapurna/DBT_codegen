{{ config(materialized='table') }}

SELECT DISTINCT
  R.FARMERS_STATE_CD AS farmers_state_cd,
  R.STATE_CODE AS state_code
FROM {{ source('fdr', 'ref_tfarmers_state') }} R
WHERE R.END_EFF_DT = '2999-12-31'
ORDER BY FARMERS_STATE_CD