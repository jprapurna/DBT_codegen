-- Purpose: Insert data into the table W_CLAIM_CD_BUR_SCD3_I
SELECT 
    * 
FROM {{ ref('int_mplt_CDM_ROW_WID') }}
WHERE EXISTS (
    SELECT 1 
    FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
    WHERE o_Flag = 'I'
)