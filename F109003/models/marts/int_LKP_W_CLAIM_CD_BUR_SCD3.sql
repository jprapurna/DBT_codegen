-- Purpose: Lookup transformation to fetch fields from CDM.W_CLAIM_CD_BUR_SCD3
WITH lookup_data AS (
    SELECT 
        ROW_WID AS lkp_ROW_WID, 
        INTEGRATION_ID AS lkp_INTEGRATION_ID, 
        NEW_BUR AS lkp_NEW_BUR 
    FROM 
        {{ source('genai_power_bi', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT 
    lkp_ROW_WID, 
    lkp_INTEGRATION_ID, 
    lkp_NEW_BUR 
FROM 
    lookup_data