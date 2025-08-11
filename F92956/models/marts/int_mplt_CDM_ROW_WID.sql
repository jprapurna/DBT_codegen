-- Purpose: Process target table name and row identifier.

SELECT 
    TGT_TABLE_NAME,
    ROW_WID
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'lkp_MAX_ROW_WID') }}
WHERE TABLE_NAME = 'W_CLAIM_CD_BUR_SCD3'