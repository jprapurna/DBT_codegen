{{
  config(materialized='table')
}}

SELECT 
  NEW_BUR,
  OLD_BUR
FROM {{ ref('int_cdm__w_claim_cd_bur_scd3') }}
WHERE o_Flag = 'I'