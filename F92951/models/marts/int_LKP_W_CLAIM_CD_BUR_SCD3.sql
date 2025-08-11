-- Purpose: Retrieves fields from W_CLAIM_CD_BUR_SCD3 using lookup.
WITH lkp_claim_cd_bur_scd3 AS (
    SELECT 
        LKP_ROW_WID, 
        LKP_INTEGRATION_ID, 
        LKP_NEW_BUR
    FROM 
        {{ source('IICS', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
SELECT 
    LKP_ROW_WID, 
    LKP_INTEGRATION_ID, 
    LKP_NEW_BUR
FROM 
    lkp_claim_cd_bur_scd3