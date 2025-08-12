-- Purpose: Set flags and timestamps based on lookup results
WITH flag_data AS (
    SELECT 
        CASE 
            WHEN ISNULL(lkp_row_wid) THEN 'I' 
            WHEN MD5(bur) = MD5(lkp_new_bur) THEN 'NC' 
            ELSE 'U' 
        END AS o_flag,
        CURRENT_TIMESTAMP() AS cdm_insert_dt,
        CURRENT_TIMESTAMP() AS cdm_update_dt,
        'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
    FROM {{ ref('int_LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT 
    o_flag, 
    cdm_insert_dt, 
    cdm_update_dt, 
    tgt_table_name
FROM flag_data