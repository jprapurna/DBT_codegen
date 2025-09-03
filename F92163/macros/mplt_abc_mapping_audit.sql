{% macro mplt_abc_mapping_audit(mapping_name, folder_name, workflow_name) %}
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
    ROW_NUMBER() OVER () AS v_RECORD_NUM,
    CASE 
      WHEN ROW_NUMBER() OVER () = 1 THEN (
        SELECT MAP_ID 
        FROM {{ source('schema', 'table') }} 
        WHERE MAPPING_NAME = input_transformation.MAPPING_NAME 
          AND FOLDER_NAME = input_transformation.FOLDER_NAME
      )
      ELSE NULL
    END AS v_MAPNG_ID,
    CASE 
      WHEN ROW_NUMBER() OVER () = 1 THEN (
        CASE 
          WHEN (
            SELECT WORKFLOW_RUN_ID 
            FROM {{ source('schema', 'table') }} 
            WHERE WORKFLOW_NAME = input_transformation.WORKFLOW_NAME
          ) IS NULL THEN (
            SELECT WORKFLOW_RUN_ID 
            FROM {{ source('schema', 'table') }} 
            WHERE WORKFLOW_NAME = input_transformation.WORKFLOW_NAME
          )
          ELSE (
            SELECT WORKFLOW_RUN_ID 
            FROM {{ source('schema', 'table') }} 
            WHERE WORKFLOW_NAME = input_transformation.WORKFLOW_NAME
          )
        END
      )
      ELSE NULL
    END AS v_WRK_FLOW_RUN_ID,
    v_MAPNG_ID AS CR_BY_MAPNG_ID,
    CURRENT_TIMESTAMP AS DW_CR_TMSP,
    v_MAPNG_ID AS UPD_BY_MAPNG_ID,
    CURRENT_TIMESTAMP AS DW_UPD_TMSP,
    v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
  FROM input_transformation
)

SELECT 
  CR_BY_MAPNG_ID,
  DW_CR_TMSP,
  UPD_BY_MAPNG_ID,
  DW_UPD_TMSP,
  WRK_FLOW_RUN_ID
FROM expression_transformation
{% endmacro %}