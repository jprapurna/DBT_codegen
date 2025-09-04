{{ config(materialized='view') }}

WITH lkp_w_claim_cd_bur_scd3 AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    *
FROM lkp_w_claim_cd_bur_scd3