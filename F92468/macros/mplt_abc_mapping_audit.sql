{% macro mplt_abc_mapping_audit(mapping_name, folder_name, workflow_name) %}
WITH input_data AS (
  SELECT
    '{{ mapping_name }}' AS MAPPING_NAME,
    '{{ folder_name }}' AS FOLDER_NAME,
    '{{ workflow_name }}' AS WORKFLOW_NAME,
    0 AS v_RECORD_NUM
),

intermediate_data AS (
  SELECT
    MAPPING_NAME,
    FOLDER_NAME,
    WORKFLOW_NAME,
    v_RECORD_NUM + 1 AS v_RECORD_NUM,
    CASE 
      WHEN v_RECORD_NUM = 1 THEN (
        SELECT MAP_ID 
        FROM {{ source('schema', 'table') }} 
        WHERE MAPPING_NAME = '{{ mapping_name }}' AND FOLDER_NAME = '{{ folder_name }}'
      )
      ELSE v_MAPNG_ID
    END AS v_MAPNG_ID,
    CASE 
      WHEN v_RECORD_NUM = 1 THEN (
        CASE 
          WHEN (
            SELECT WORKFLOW_RUN_ID 
            FROM {{ source('schema', 'table') }} 
            WHERE WORKFLOW_NAME = '{{ workflow_name }}'
          ) IS NULL THEN (
            SELECT WORKFLOW_RUN_ID 
            FROM {{ source('schema', 'table') }} 
            WHERE WORKFLOW_NAME = '{{ workflow_name }}'
          )
          ELSE (
            SELECT WORKFLOW_RUN_ID 
            FROM {{ source('schema', 'table') }} 
            WHERE WORKFLOW_NAME = '{{ workflow_name }}'
          )
        END
      )
      ELSE v_WRK_FLOW_RUN_ID
    END AS v_WRK_FLOW_RUN_ID
  FROM input_data
),

final_output AS (
  SELECT
    v_MAPNG_ID AS CR_BY_MAPNG_ID,
    CURRENT_TIMESTAMP AS DW_CR_TMSP,
    v_MAPNG_ID AS UPD_BY_MAPNG_ID,
    CURRENT_TIMESTAMP AS DW_UPD_TMSP,
    v_WRK_FLOW_RUN_ID AS WRK_FLOW_RUN_ID
  FROM intermediate_data
)

SELECT * FROM final_output
{% endmacro %}