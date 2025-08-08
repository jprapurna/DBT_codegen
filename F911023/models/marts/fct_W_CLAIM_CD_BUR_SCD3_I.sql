-- Purpose: Insert data into the table W_CLAIM_CD_BUR_SCD3_I.

WITH row_wid_calculation AS (
    SELECT 
        tgt_table_name, 
        v1, 
        v2, 
        row_wid
    FROM {{ ref('int_exp_ROW_WID') }}
),
router_logic AS (
    SELECT 
        o_flag, 
        cdm_insert_dt, 
        cdm_update_dt, 
        tgt_table_name,
        insert,
        update
    FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
)

SELECT 
    row_wid_calculation.tgt_table_name, 
    row_wid_calculation.v1, 
    row_wid_calculation.v2, 
    row_wid_calculation.row_wid,
    router_logic.o_flag, 
    router_logic.cdm_insert_dt, 
    router_logic.cdm_update_dt, 
    router_logic.tgt_table_name,
    router_logic.insert,
    router_logic.update
FROM row_wid_calculation
JOIN router_logic ON row_wid_calculation.tgt_table_name = router_logic.tgt_table_name