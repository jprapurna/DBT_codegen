-- Purpose: Insert operation into W_CLAIM_CD_BUR_SCD3_I
SELECT 
    * 
FROM 
    {{ ref('int_rtr_CLM_INSERT_UPD') }}
JOIN 
    {{ ref('int_mplt_CDM_ROW_WID') }} 
ON 
    {{ ref('int_rtr_CLM_INSERT_UPD') }}.TGT_TABLE_NAME = {{ ref('int_mplt_CDM_ROW_WID') }}.TABLE_NAME