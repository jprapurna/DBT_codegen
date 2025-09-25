{{ config(materialized='table') }}

SELECT 
  * 
FROM {{ ref('int_claim_cd_bur__exp_row_wid') }}