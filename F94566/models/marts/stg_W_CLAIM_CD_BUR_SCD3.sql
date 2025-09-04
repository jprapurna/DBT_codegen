{{ config(materialized='view') }}

WITH w_claim_cd_bur_scd3 AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_CDM', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    *
FROM w_claim_cd_bur_scd3