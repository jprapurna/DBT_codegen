{{ config(materialized='view') }}

WITH wf_w_claim_cd_scd3_iu_data AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'wf_W_CLAIM_CD_SCD3_IU') }}
)
SELECT
    *
FROM wf_w_claim_cd_scd3_iu_data