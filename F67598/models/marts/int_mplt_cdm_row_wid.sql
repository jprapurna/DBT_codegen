-- Purpose: Generates ROW_WID based on input fields and variable bindings.
WITH row_wid_data AS (
    SELECT 
        tgt_table_name,
        {{ lkp_max_row_wid('W_CLAIM_CD_BUR_SCD3') }}
    FROM {{ ref('int_upd_bur') }}
)
SELECT * FROM row_wid_data