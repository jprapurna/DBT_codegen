{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "DUMMY_LKP_W_CLAIM_CD_BUR_SCD3" AS dummy_lkp_w_claim_cd_bur_scd3 -- Error: Table does not exist or not authorized
    FROM {{ source('CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    dummy_lkp_w_claim_cd_bur_scd3
FROM source_data