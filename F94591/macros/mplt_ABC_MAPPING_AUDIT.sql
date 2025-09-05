{% macro mplt_ABC_MAPPING_AUDIT(mapping_name, folder_name, workflow_name) %}
WITH input_transformation AS (
  SELECT
    '{{ mapping_name }}' AS MAPPING_NAME,
    '{{ folder_name }}' AS FOLDER_NAME,
    '{{ workflow_name }}' AS WORKFLOW_NAME
),

expression_transformation AS (
  SELECT
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    -- Increment record number
    ROW_NUMBER() OVER () AS v_RECORD_NUM,
    -- Mapping ID lookup
    CASE 
      WHEN ROW_NUMBER() OVER () = 1 THEN (
        CASE 
          WHEN :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME) IS NOT NULL THEN :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME)
          ELSE NULL
        END
      )
      ELSE NULL
    END AS v_MAPNG_ID,
    -- Workflow run ID lookup
    CASE 
      WHEN ROW_NUMBER() OVER () = 1 THEN (
        CASE 
          WHEN :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME) IS NOT NULL THEN :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)
          ELSE :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME)
        END
      )
      ELSE NULL
    END AS v_WRK_FLOW_RUN_ID,
    -- Created by mapping ID
    CASE 
      WHEN ROW_NUMBER() OVER () = 1 THEN :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME)
      ELSE NULL
    END AS CR_BY_MAPNG_ID,
    -- Creation timestamp
    CURRENT_TIMESTAMP AS DW_CR_TMSP,
    -- Updated by mapping ID
    CASE 
      WHEN ROW_NUMBER() OVER () = 1 THEN :LKP.lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME)
      ELSE NULL
    END AS UPD_BY_MAPNG_ID,
    -- Update timestamp
    CURRENT_TIMESTAMP AS DW_UPD_TMSP,
    -- Workflow run ID
    CASE 
      WHEN ROW_NUMBER() OVER () = 1 THEN (
        CASE 
          WHEN :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME) IS NOT NULL THEN :LKP.LKP_WORKFLOW_RUN_ID_ABC(WORKFLOW_NAME)
          ELSE :LKP.lkp_WORKFLOW_RUN_ID(WORKFLOW_NAME)
        END
      )
      ELSE NULL
    END AS WRK_FLOW_RUN_ID
  FROM input_transformation
)

SELECT 
  MAPPING_NAME,
  FOLDER_NAME,
  WORKFLOW_NAME,
  CR_BY_MAPNG_ID,
  DW_CR_TMSP,
  UPD_BY_MAPNG_ID,
  DW_UPD_TMSP,
  WRK_FLOW_RUN_ID
FROM expression_transformation
{% endmacro %}