{{ config(materialized='view') }}

SELECT
    W_CLAIM_CD_BUR_SCD3_I AS w_claim_cd_bur_scd3_i -- Claim code burden SCD3 insert operations
FROM {{ source('Snowflake_CDM', 'W_CLAIM_CD_BUR_SCD3_I') }}