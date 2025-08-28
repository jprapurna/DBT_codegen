{{ config(materialized='table') }}
WITH final_data AS (
    SELECT 
        ROW_WID,
        INTEGRATION_ID,
        BUR AS NEW_BUR,
        NULL AS OLD_BUR,
        SYSDATE() AS INSERT_DT,
        SYSDATE() AS UPDATE_DT
    FROM {{ ref('int_flag_evaluation') }}
    WHERE o_Flag = 'I'
    UNION ALL
    SELECT 
        ROW_WID,
        INTEGRATION_ID,
        BUR AS NEW_BUR,
        lkp_NEW_BUR AS OLD_BUR,
        NULL AS INSERT_DT,
        SYSDATE() AS UPDATE_DT
    FROM {{ ref('int_flag_evaluation') }}
    WHERE o_Flag = 'U'
)
SELECT * FROM final_data