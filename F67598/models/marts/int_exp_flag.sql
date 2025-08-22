-- Purpose: Evaluates input fields and applies expressions to generate output fields such as flags, timestamps, and target table names.
WITH input_data AS (
    SELECT 
        integration_id,
        bur,
        source_name,
        o_batch_id,
        lkp_row_wid,
        lkp_integration_id,
        lkp_new_bur
    FROM {{ ref('int_lkp_w_claim_cd_bur_scd3') }}
),
flagged_data AS (
    SELECT 
        *,
        CASE 
            WHEN lkp_row_wid IS NULL THEN 'I'
            WHEN MD5(bur) = MD5(lkp_new_bur) THEN 'NC'
            ELSE 'U'
        END AS o_flag,
        SYSDATE AS cdm_insert_dt,
        SYSDATE AS cdm_update_dt,
        'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
    FROM input_data
)
SELECT * FROM flagged_data