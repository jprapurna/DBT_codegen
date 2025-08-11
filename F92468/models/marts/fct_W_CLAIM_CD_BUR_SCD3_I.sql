-- Purpose: Insert operation on W_CLAIM_CD_BUR_SCD3_I
SELECT 
    *
FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
WHERE o_Flag = 'I'