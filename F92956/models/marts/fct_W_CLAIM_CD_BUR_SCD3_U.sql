-- Purpose: Update data in W_CLAIM_CD_BUR_SCD3_U based on Update Strategy Expression.

WITH source_data AS (
    SELECT 
        INTEGRATION_ID,
        o_Flag,
        BATCH_ID
    FROM {{ ref('int_UPD_BUR') }}
)

SELECT 
    INTEGRATION_ID,
    o_Flag,
    BATCH_ID
FROM source_data
WHERE o_Flag = 'U'