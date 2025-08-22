{{ config(materialized='table') }}
WITH flag_evaluation AS (
    SELECT 
        integration_id,
        bur,
        source_name,
        {{ ref('int_w_claim_cd_bur_scd3') }}.lkp_row_wid,
        {{ ref('int_w_claim_cd_bur_scd3') }}.lkp_integration_id,
        {{ ref('int_w_claim_cd_bur_scd3') }}.lkp_new_bur,
        {{ scd3_flag_evaluation('bur', 'lkp_new_bur', 'lkp_row_wid') }} AS flag,
        CURRENT_TIMESTAMP AS insert_dt,
        CURRENT_TIMESTAMP AS update_dt
    FROM {{ ref('int_cdh_gw_bur') }}
    LEFT JOIN {{ ref('int_w_claim_cd_bur_scd3') }}
    ON {{ ref('int_cdh_gw_bur') }}.integration_id = {{ ref('int_w_claim_cd_bur_scd3') }}.lkp_integration_id
)
SELECT * FROM flag_evaluation