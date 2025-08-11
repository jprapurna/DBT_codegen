-- Purpose: Route data for insert and update operations based on flags.

WITH source_data AS (
    SELECT 
        INTEGRATION_ID,
        o_BATCH_ID,
        LKP_ROW_WID,
        LKP_INTEGRATION_ID,
        LKP_NEW_BUR,
        o_Flag,
        CDM_INSERT_DT,
        CDM_UPDATE_DT,
        TGT_TABLE_NAME
    FROM {{ ref('int_EXP_BUR') }}
)

SELECT 
    *
FROM source_data
WHERE o_Flag IN ('I', 'U')