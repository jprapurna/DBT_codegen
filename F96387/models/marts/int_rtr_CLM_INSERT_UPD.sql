-- Purpose: Route data based on 'o_Flag'
WITH router_data AS (
    SELECT 
        o_flag, 
        cdm_insert_dt, 
        cdm_update_dt, 
        tgt_table_name
    FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
    o_flag, 
    cdm_insert_dt, 
    cdm_update_dt, 
    tgt_table_name
FROM router_data
WHERE o_flag = 'I' OR o_flag = 'U'