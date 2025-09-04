{{ config(materialized='view') }}

WITH dev_clm_bi_cdm_w_claim_cd_bur_scd3 AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse_CDM', 'DEV_CLM_BI/CDM/W_CLAIM_CD_BUR_SCD3') }}
)
SELECT
    *
FROM dev_clm_bi_cdm_w_claim_cd_bur_scd3