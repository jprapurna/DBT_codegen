{{ config(materialized='table') }}

SELECT * 
FROM {{ ref('int_claim_cd__rtr_clm_insert_upd') }}