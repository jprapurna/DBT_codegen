{{ config(materialized='view') }}

WITH w_claim_cd_bur_scd3_i AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_V2', 'W_CLAIM_CD_BUR_SCD3_I') }}
)
SELECT
    *
FROM w_claim_cd_bur_scd3_i