-- Purpose: Update strategy expression for data updates.

WITH source_data AS (
    SELECT 
        in_INTEGRATION_ID,
        LKP_INTEGRATION_ID,
        o_Flag,
        BATCH_ID
    FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
)

SELECT 
    in_INTEGRATION_ID,
    LKP_INTEGRATION_ID,
    o_Flag,
    BATCH_ID,
    'DD_UPDATE' AS Update_Strategy_Expression_78066
FROM source_data
WHERE o_Flag = 'U'