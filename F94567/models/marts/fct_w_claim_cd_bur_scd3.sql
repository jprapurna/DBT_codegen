{{ config(materialized='table') }}

SELECT *
FROM {{ ref('int_w_claim_cd_bur_scd3_u') }}