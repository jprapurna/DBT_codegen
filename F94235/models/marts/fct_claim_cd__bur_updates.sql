{{ config(materialized='table') }}

SELECT * 
FROM {{ ref('int_claim_cd__upd_bur') }}