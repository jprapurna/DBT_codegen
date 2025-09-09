{{
  config(materialized='table')
}}

SELECT
  *
FROM {{ ref('int_cdm_claim_cd_bur_scd3__insert') }}

UNION ALL

SELECT
  *
FROM {{ ref('int_cdm_claim_cd_bur_scd3__update') }}