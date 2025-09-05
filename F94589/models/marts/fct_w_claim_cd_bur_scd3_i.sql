{{
  config(materialized='table')
}}

SELECT * FROM {{ ref('int_cdm__w_claim_cd_bur_scd3') }}