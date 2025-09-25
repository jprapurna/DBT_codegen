-- Transformation node: int_ABC_MAPPING_AUDIT_INPUT
WITH int_ABC_MAPPING_AUDIT_INPUT AS (
    SELECT 
        '$PMMappingName' AS MAPPING_NAME, -- Mapping name constant
        '$PMFolderName' AS FOLDER_NAME,  -- Folder name constant
        '$PMWorkflowName' AS WORKFLOW_NAME -- Workflow name constant
)


-- Transformation node: exp_ABC_MAPPING_AUDIT_ID_LOOKUP
, exp_ABC_MAPPING_AUDIT_ID_LOOKUP AS (
    SELECT 
        'mplt_ABC_MAPPING_AUDIT' AS MAPPING_NAME, -- Mapping name constant
        NULL AS FOLDER_NAME, -- Placeholder for folder name
        NULL AS WORKFLOW_NAME, -- Placeholder for workflow name
        v_RECORD_NUM + 1 AS v_RECORD_NUM, -- Increment record number
        CASE 
            WHEN v_RECORD_NUM = 1 THEN :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME) 
            ELSE v_MAPNG_ID 
        END AS v_MAPNG_ID, -- Lookup mapping ID
        CASE 
            WHEN v_RECORD_NUM = 1 THEN 
                CASE 
                    WHEN ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)) THEN :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME) 
                    ELSE :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME) 
                END
            ELSE v_WRK_FLOW_RUN_ID 
        END AS v_WRK_FLOW_RUN_ID, -- Lookup workflow run ID
        v_MAPNG_ID AS CR_BY_MAPNG_ID, -- Created by mapping ID
        SESSSTARTTIME AS DW_CR_TMSP, -- Session start time for creation timestamp
        v_MAPNG_ID AS UPD_BY_MAPNG_ID, -- Updated by mapping ID
        SESSSTARTTIME AS DW_UPD_TMSP, -- Session start time for update timestamp
        v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID -- Workflow run ID
    FROM <PREVIOUS_NODE_NAME> -- Replace with actual previous node name
)


-- Transformation node: out_ABC_MAPPING_AUDIT_OUTPUT
, out_ABC_MAPPING_AUDIT_OUTPUT AS (
    SELECT 
        MAPPING_NAME,
        FOLDER_NAME,
        WORKFLOW_NAME,
        v_RECORD_NUM + 1 AS v_RECORD_NUM,
        CASE 
            WHEN v_RECORD_NUM = 1 THEN :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME)
            ELSE v_MAPNG_ID
        END AS v_MAPNG_ID,
        CASE 
            WHEN v_RECORD_NUM = 1 THEN 
                CASE 
                    WHEN ISNULL(:LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)) THEN :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME)
                    ELSE :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)
                END
            ELSE v_WRK_FLOW_RUN_ID
        END AS v_WRK_FLOW_RUN_ID,
        v_MAPNG_ID AS CR_BY_MAPNG_ID,
        SESSSTARTTIME AS DW_CR_TMSP,
        v_MAPNG_ID AS UPD_BY_MAPNG_ID,
        SESSSTARTTIME AS DW_UPD_TMSP,
        v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
    FROM exp_ABC_MAPPING_AUDIT_ID_LOOKUP
)