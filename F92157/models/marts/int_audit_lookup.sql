WITH audit_details AS (
    SELECT
        MAPPING_NAME,
        FOLDER_NAME,
        WORKFLOW_NAME,
        ROW_NUMBER() OVER (ORDER BY MAPPING_NAME) AS v_RECORD_NUM,
        {{ generate_mapping_id('MAPPING_NAME', 'FOLDER_NAME') }} AS v_MAPNG_ID,
        {{ generate_workflow_run_id('WORKFLOW_NAME') }} AS v_WRK_FLOW_RUN_ID,
        v_MAPNG_ID AS CR_BY_MAPNG_ID,
        CURRENT_TIMESTAMP AS DW_CR_TMSP,
        v_MAPNG_ID AS UPD_BY_MAPNG_ID,
        CURRENT_TIMESTAMP AS DW_UPD_TMSP,
        v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
    FROM some_source_table
)
SELECT *
FROM audit_details