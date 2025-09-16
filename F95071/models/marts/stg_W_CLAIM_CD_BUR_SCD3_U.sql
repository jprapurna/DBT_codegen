{{ config(materialized='view') }}

SELECT
    W_CLAIM_CD_BUR_SCD3_U AS w_claim_cd_bur_scd3_u -- Claim code burden SCD3 update operations
FROM {{ source('Snowflake_CDM', 'W_CLAIM_CD_BUR_SCD3_U') }}