-- Purpose: Inserts data into W_CLAIM_CD_BUR_SCD3_I.
WITH claim_cd_bur_scd3_i AS (
    SELECT 
        *
    FROM 
        {{ ref('int_rtr_CLM_INSERT_UPD') }}
    WHERE 
        o_flag = 'I'
)
SELECT 
    *
FROM 
    claim_cd_bur_scd3_i