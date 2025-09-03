{{
  config(materialized='table')
}}

SELECT *
FROM {{ ref('int_cdm__claim_cd_bur_scd3') }}