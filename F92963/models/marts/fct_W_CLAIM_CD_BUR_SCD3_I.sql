-- Purpose: Insert data into W_CLAIM_CD_BUR_SCD3_I
WITH insert_fact_data AS (
    SELECT 
        INTEGRATION_ID, 
        o_Flag, 
        CDM_INSERT_DT, 
        CDM_UPDATE_DT
    FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
    WHERE o_Flag = 'I'
)
SELECT 
    INTEGRATION_ID, 
    o_Flag, 
    CDM_INSERT_DT, 
    CDM_UPDATE_DT
FROM insert_fact_data