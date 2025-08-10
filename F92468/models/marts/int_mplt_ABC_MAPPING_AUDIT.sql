-- Purpose: Mapplet for auditing mapping details, including mapping name, folder name, and workflow name
WITH audit_cte AS (
    SELECT 
        MAPPING_NAME,
        FOLDER_NAME,
        WORKFLOW_NAME,
        CR_BY_MAPNG_ID,
        UPD_BY_MAPNG_ID,
        DW_UPD_TMSP,
        WRK_FLOW_RUN_ID
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT 
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    CR_BY_MAPNG_ID,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
FROM audit_cte