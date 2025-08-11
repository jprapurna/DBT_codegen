-- Purpose: Generates ROW_WID based on input TGT_TABLE_NAME.
WITH mplt_cdm_row_wid AS (
    SELECT 
        ROW_WID
    FROM 
        {{ source('IICS', 'lkp_MAX_ROW_WID') }}
    WHERE 
        TABLE_NAME = 'W_CLAIM_CD_BUR_SCD3'
)
SELECT 
    ROW_WID
FROM 
    mplt_cdm_row_wid