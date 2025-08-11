-- Purpose: Sets flags and timestamps based on conditions.
WITH exp_flag AS (
    SELECT 
        IIF(ISNULL(LKP_ROW_WID), 'I', IIF(MD5(BUR) = MD5(LKP_NEW_BUR), 'NC', 'U')) AS o_flag,
        CURRENT_TIMESTAMP() AS cdm_insert_dt,
        CURRENT_TIMESTAMP() AS cdm_update_dt,
        'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
    FROM 
        {{ ref('int_LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT 
    o_flag, 
    cdm_insert_dt, 
    cdm_update_dt, 
    tgt_table_name
FROM 
    exp_flag