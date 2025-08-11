-- Purpose: Update data in W_CLAIM_CD_BUR_SCD3_U based on Update Strategy Expression
WITH update_fact_data AS (
    SELECT 
        INTEGRATION_ID, 
        o_Flag, 
        BATCH_ID
    FROM {{ ref('int_UPD_BUR') }}
    WHERE o_Flag = 'U'
)
SELECT 
    INTEGRATION_ID, 
    o_Flag, 
    BATCH_ID
FROM update_fact_data