-- Purpose: Route data based on 'o_Flag'.

WITH flags_and_timestamps AS (
    SELECT 
        integration_id, 
        o_batch_id, 
        lkp_row_wid, 
        lkp_integration_id, 
        lkp_new_bur,
        IIF(ISNULL(lkp_row_wid), 'I', IIF(MD5(BUR) = MD5(lkp_new_bur), 'NC', 'U')) AS o_flag,
        SYSDATE AS cdm_insert_dt,
        SYSDATE AS cdm_update_dt,
        'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
    FROM {{ ref('int_CDH_GW_BUR') }}
)

SELECT 
    o_flag, 
    cdm_insert_dt, 
    cdm_update_dt, 
    tgt_table_name,
    CASE WHEN o_flag = 'I' THEN TRUE ELSE FALSE END AS insert,
    CASE WHEN o_flag = 'U' THEN TRUE ELSE FALSE END AS update
FROM flags_and_timestamps