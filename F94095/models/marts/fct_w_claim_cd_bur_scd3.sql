-- Purpose: Final model for SCD3 logic implementation
{{ config(materialized='table') }}

WITH base_data AS (
    SELECT 
        INTEGRATION_ID,
        BUR,
        SOURCE_NAME,
        o_BATCH_ID,
        ROW_WID,
        CASE 
            WHEN ROW_WID IS NULL THEN 'I'
            WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
            ELSE 'U'
        END AS o_Flag,
        SYSDATE AS CDM_INSERT_DT,
        SYSDATE AS CDM_UPDATE_DT,
        {{ ref('mapplet_tgt_table_name') }} AS TGT_TABLE_NAME
    FROM {{ ref('int_cdh_gw_bur') }}
    LEFT JOIN {{ ref('lkp_w_claim_cd_bur_scd3') }} ON INTEGRATION_ID = lkp_INTEGRATION_ID
)
SELECT * FROM base_data
WHERE o_Flag IN ('I', 'U')