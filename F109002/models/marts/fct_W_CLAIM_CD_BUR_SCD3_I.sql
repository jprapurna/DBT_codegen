-- Purpose: Insert operation on W_CLAIM_CD_BUR_SCD3_I
WITH insert_data AS (
    SELECT 
        * 
    FROM {{ ref('int_rtr_CLM_INSERT_UPD') }}
    JOIN {{ ref('int_mplt_CDM_ROW_WID') }} ON TGT_TABLE_NAME = TGT_TABLE_NAME
)
SELECT 
    * 
FROM insert_data