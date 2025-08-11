-- Purpose: Extract data from CDH_GW_BUR with custom SQL query, ensuring precise data extraction.

WITH source_data AS (
    SELECT 
        POLICY_STATE,
        BUR,
        'GWCDH' AS SOURCE_NAME
    FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'SQ_CDH_GW_BUR') }}
),
lookup_data AS (
    SELECT 
        ROW_WID AS lkp_ROW_WID, 
        INTEGRATION_ID AS lkp_INTEGRATION_ID, 
        NEW_BUR AS lkp_NEW_BUR 
    FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)

SELECT 
    sd.POLICY_STATE,
    sd.BUR,
    sd.SOURCE_NAME,
    ld.lkp_ROW_WID,
    ld.lkp_INTEGRATION_ID,
    ld.lkp_NEW_BUR
FROM source_data sd
LEFT JOIN lookup_data ld
ON ld.lkp_INTEGRATION_ID = sd.POLICY_STATE