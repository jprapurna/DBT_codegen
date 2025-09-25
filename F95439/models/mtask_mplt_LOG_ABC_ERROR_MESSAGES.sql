-- Transformation node: seq_MSG_ID_SK
WITH seq_MSG_ID_SK AS (
    SELECT 
        NEXTVAL AS NEXTVAL, -- Generates the next sequence value based on the defined attributes
        CURRVAL AS CURRVAL  -- Provides the current sequence value
)


-- Lookup node: lkp_STD_MSG_ID
, lkp_STD_MSG_ID AS (
    SELECT 
        lkp.STD_MSG_ID,
        lkp.SYS_MSG_CD,
        lkp.I_SYS_MSG_CD
    FROM {{ source('fire_policy', 'ABC_CTRL_SYS_STD_MSGS') }} AS lkp
    LEFT JOIN <PREVIOUS_NODE_NAME> AS src
    ON lkp.SYS_MSG_CD = src.i_SYS_MSG_CD
)


-- Source node: int_ABC_ERROR_MAPPLET_INPUT
, int_ABC_ERROR_MAPPLET_INPUT AS (
    SELECT 
        NULL AS WRKFL_NM, -- Workflow name
        NULL AS WRKFL_CMPNT_NM, -- Workflow component name
        NULL AS CMPNT_MODULE_NM, -- Component module name
        NULL AS SYS_MSG_CD, -- System message code
        NULL AS ERR_DESC, -- Error description
        NULL AS CMPNT_MODULE_PK, -- Component module primary key
        'mplt_LOG_ABC_ERROR_MESSAGES' AS MAPPING_NAME, -- Mapping name
        NULL AS FOLDER_NAME -- Folder name
)


{{ config(
    materialized='incremental',
    alias='ABC_CTRL_SYS_MSG',
    unique_key='MSG_ID',
    incremental_strategy='insert',
    on_schema_change='append_new_columns',
    merge_update_columns=[
        'MSG_ID',
        'WRKFL_CMPNT_ID',
        'WRKFL_RUN_ID',
        'STD_MSG_ID',
        'WRKFL_NM',
        'WRKFL_CMPNT_NM',
        'MSG_TMSP',
        'CMPNT_MODULE_NM',
        'ERR_STAT',
        'ERR_DESC',
        'ERR_RESOLUTION_TMSP',
        'CMPNT_MODULE_PK',
        'WRKFL_MAPNG_ID'
    ]
) }}

final AS (
    SELECT
        'DD_INSERT' AS MSG_ID,
        'DD_INSERT' AS WRKFL_CMPNT_ID,
        'DD_INSERT' AS WRKFL_RUN_ID,
        'DD_INSERT' AS STD_MSG_ID,
        'DD_INSERT' AS WRKFL_NM,
        'DD_INSERT' AS WRKFL_CMPNT_NM,
        'DD_INSERT' AS MSG_TMSP,
        'DD_INSERT' AS CMPNT_MODULE_NM,
        'DD_INSERT' AS ERR_STAT,
        'DD_INSERT' AS ERR_DESC,
        'DD_INSERT' AS ERR_RESOLUTION_TMSP,
        'DD_INSERT' AS CMPNT_MODULE_PK,
        'DD_INSERT' AS WRKFL_MAPNG_ID
)

SELECT * FROM final


-- Transformation node: exp_ASSIGN_ERROR_ID_AND_VALUES
, exp_ASSIGN_ERROR_ID_AND_VALUES AS (
    SELECT 
        '$PMMappingName' AS MAPPING_NAME, -- Metadata field
        NULL AS FOLDER_NAME, -- Placeholder for folder name
        NULL AS i_STD_MSG_ID, -- Placeholder for standard message ID
        WRKFL_NM AS WRKFL_NM, -- Workflow name
        WRKFL_CMPNT_NM AS WRKFL_CMPNT_NM, -- Workflow component name
        CASE 
            WHEN v_RECORD_NUM IS NULL THEN 1 
            ELSE v_RECORD_NUM + 1 
        END AS v_RECORD_NUM, -- Record number logic
        CASE 
            WHEN v_RECORD_NUM = 1 THEN lkp_FDR_LIB_WRKFL_CMPNT_ID(WRKFL_CMPNT_NM) 
            ELSE v_WRKFL_CMPNT_ID 
        END AS v_WRKFL_CMPNT_ID, -- Workflow component ID lookup
        CASE 
            WHEN v_RECORD_NUM = 1 THEN lkp_FDR_LIB_WORKFLOW_RUN_ID(WRKFL_NM) 
            ELSE v_WRKFL_RUN_ID 
        END AS v_WRKFL_RUN_ID, -- Workflow run ID lookup
        CASE 
            WHEN v_WRKFL_CMPNT_ID IS NULL THEN 0 
            ELSE v_WRKFL_CMPNT_ID 
        END AS WRKFL_CMPNT_ID, -- Workflow component ID assignment
        CASE 
            WHEN v_WRKFL_RUN_ID IS NULL THEN 0 
            ELSE v_WRKFL_RUN_ID 
        END AS WRKFL_RUN_ID, -- Workflow run ID assignment
        CASE 
            WHEN i_STD_MSG_ID IS NULL THEN 0 
            ELSE i_STD_MSG_ID 
        END AS STD_MSG_ID, -- Standard message ID assignment
        CMPNT_MODULE_NM AS CMPNT_MODULE_NM, -- Component module name
        ERR_DESC AS ERR_DESC, -- Error description
        SESSSTARTTIME AS o_MSG_TMSP, -- Session start time
        'OPEN' AS o_ERR_STAT, -- Error status
        NULL AS o_ERR_RESOLUTION_TMSP, -- Placeholder for error resolution timestamp
        CMPNT_MODULE_PK AS CMPNT_MODULE_PK, -- Component module primary key
        lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME) AS o_WRKFL_MAPNG_ID -- Mapping ID lookup
    FROM previous_node_name -- Replace with actual previous node name
)


-- Transformation node: out_ABC_ERROR_MAPPLET_OUTPUT
, out_ABC_ERROR_MAPPLET_OUTPUT AS (
    SELECT 
        MSG_ID,
        WRKFL_CMPNT_ID,
        WRKFL_RUN_ID,
        STD_MSG_ID,
        WRKFL_NM,
        WRKFL_CMPNT_NM,
        MSG_TMSP,
        CMPNT_MODULE_NM,
        ERR_STAT,
        ERR_DESC,
        ERR_RESOLUTION_TMSP,
        CMPNT_MODULE_PK,
        WRKFL_MAPNG_ID
    FROM upd_INSERT_ERROR_RECORD
)