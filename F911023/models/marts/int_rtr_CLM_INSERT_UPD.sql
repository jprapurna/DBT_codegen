-- Purpose: Route data based on 'o_Flag'.

WITH router_logic AS (
    SELECT 
        o_flag, 
        cdm_insert_dt, 
        cdm_update_dt, 
        tgt_table_name,
        CASE WHEN o_flag = 'I' THEN TRUE ELSE FALSE END AS insert,
        CASE WHEN o_flag = 'U' THEN TRUE ELSE FALSE END AS update
    FROM {{ ref('int_EXP_Flag') }}
)

SELECT 
    o_flag, 
    cdm_insert_dt, 
    cdm_update_dt, 
    tgt_table_name,
    insert,
    update
FROM router_logic