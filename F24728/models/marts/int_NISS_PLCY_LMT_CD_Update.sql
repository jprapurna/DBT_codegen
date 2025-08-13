-- Purpose: To apply update strategy on NISS_PLCY_LMT_CD field
WITH source_data AS (
    SELECT 
        NISS_APRM_DETL_SK,
        NISS_PLCY_LMT_CD
    FROM 
        {{ ref('FDR_LIB_WRK_BIRP_NISS_APRM_DETL1') }}
)

SELECT 
    NISS_APRM_DETL_SK,
    NISS_PLCY_LMT_CD
FROM 
    source_data
WHERE 
    -- Apply update strategy logic here
    -- Assuming DD_UPDATE logic is implemented as a condition
    -- Forward rejected rows logic can be implemented as needed
    TRUE