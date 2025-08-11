-- Purpose: Insert data into W_CLAIM_CD_BUR_SCD3_I.

WITH source_data AS (
    SELECT 
        INTEGRATION_ID,
        o_Flag,
        BATCH_ID,
        ROW_WID
    FROM {{ ref('int_exp_ROW_WID') }}
)

SELECT 
    INTEGRATION_ID,
    o_Flag,
    BATCH_ID,
    ROW_WID
FROM source_data
WHERE o_Flag = 'I'