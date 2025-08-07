-- Purpose: Insert data into the table W_CLAIM_CD_BUR_SCD3_I
WITH insert_data AS (
    SELECT 
        * 
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
    WHERE {{ ref('int_rtr_CLM_INSERT_UPD') }}.o_Flag = 'I'
)
SELECT 
    * 
FROM insert_data