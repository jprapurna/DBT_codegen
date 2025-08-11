-- Purpose: Route data based on 'o_Flag'
WITH routed_data AS (
    SELECT 
        o_Flag, 
        CDM_INSERT_DT, 
        CDM_UPDATE_DT, 
        TGT_TABLE_NAME
    FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
    o_Flag, 
    CDM_INSERT_DT, 
    CDM_UPDATE_DT, 
    TGT_TABLE_NAME
FROM routed_data
WHERE o_Flag = 'I' OR o_Flag = 'U'