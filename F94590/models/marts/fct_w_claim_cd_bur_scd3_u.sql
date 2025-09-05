{{
  config(materialized='table')
}}

SELECT 
  ROW_WID
FROM {{ ref('int_cdm__w_claim_cd_bur_scd3') }}
WHERE o_Flag = 'U'