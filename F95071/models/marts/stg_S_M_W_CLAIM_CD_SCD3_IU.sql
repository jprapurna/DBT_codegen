{{ config(materialized='view') }}

SELECT
    s_m_W_CLAIM_CD_SCD3_IU AS s_m_w_claim_cd_scd3_iu -- Claim code SCD3 insert/update operations
FROM {{ source('Snowflake_CDM', 's_m_W_CLAIM_CD_SCD3_IU') }}