-- Purpose: Update operation on W_CLAIM_CD_BUR_SCD3_U
SELECT 
    *
FROM {{ ref('int_UPD_BUR') }}
WHERE o_Flag = 'U'