{{ config(materialized='table') }}

WITH base_data AS (
    SELECT 
        t.INTEGRATION_ID,
        t.BUR,
        t.SOURCE_NAME,
        b.BATCH_ID,
        l.lkp_ROW_WID,
        l.lkp_NEW_BUR,
        CASE
            WHEN l.lkp_ROW_WID IS NULL THEN 'I'
            WHEN MD5(t.BUR) = MD5(l.lkp_NEW_BUR) THEN 'NC'
            ELSE 'U'
        END AS operation_flag,
        CURRENT_TIMESTAMP AS insert_dt,
        CURRENT_TIMESTAMP AS update_dt
    FROM {{ ref('int_cdh_gw_bur_transformed') }} t
    LEFT JOIN {{ ref('int_cdm_batch_ctrlid_transformed') }} b
        ON t.SOURCE_NAME = b.SOURCE_NAME
    LEFT JOIN {{ ref('int_scd3_lookup') }} l
        ON t.INTEGRATION_ID = l.lkp_INTEGRATION_ID
)
SELECT * FROM base_data
WHERE operation_flag IN ('I', 'U')