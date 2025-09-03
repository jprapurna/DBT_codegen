{{ config(materialized='table') }}

SELECT *
FROM {{ ref('int_s_w_claim_cd_scd3_iu') }}
UNION ALL
SELECT *
FROM {{ ref('int_cdh_gw_bur') }}