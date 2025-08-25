{{ config(materialized='view') }}

WITH base_data AS (
    SELECT 
        ST_ABBR,
        AGE,
        GENDR,
        MRTL_STAT,
        AUTO_USE_CD,
        SOI_TYP
    FROM {{ ref('stg_upstream_model') }}
),
derived_fields AS (
    SELECT 
        ST_ABBR,
        {{ safe_null_check('AGE', '0') }} AS IAGE,
        {{ safe_null_check('AUTO_USE_CD', "''") }} AS AUTO_USE_CD,
        -- Complex logic for Toggle Auto class code derivation
        CASE 
            WHEN AUTO_USE_CD = 'T' THEN 'Toggle Auto'
            ELSE 'Other'
        END AS v_CLASS_CODE_TAuto,
        -- DECODE logic for final Toggle Auto class code
        CASE 
            WHEN v_CLASS_CODE_TAuto = 'Toggle Auto' THEN 'Final Toggle Auto'
            ELSE 'Final Other'
        END AS v_CLASS_CODE_TAuto_Final,
        -- DECODE logic for miscellaneous class codes
        CASE 
            WHEN ST_ABBR = 'CA' THEN 'Misc Code 1'
            WHEN ST_ABBR = 'NY' THEN 'Misc Code 2'
            ELSE 'Misc Code Other'
        END AS v_CLASS_CD_Misc_1,
        -- Combining miscellaneous class codes
        CASE 
            WHEN v_CLASS_CD_Misc_1 = 'Misc Code 1' THEN 'Final Misc Code 1'
            ELSE 'Final Misc Code Other'
        END AS v_CLASS_CD_Misc_Final,
        -- Combining indemnity, Toggle Auto, and miscellaneous class codes
        CASE 
            WHEN v_CLASS_CODE_TAuto_Final = 'Final Toggle Auto' THEN 'NISS Class Code Toggle Auto'
            WHEN v_CLASS_CD_Misc_Final = 'Final Misc Code 1' THEN 'NISS Class Code Misc'
            ELSE 'NISS Class Code Other'
        END AS v_NISS_CLASS_CD,
        -- Final NISS Class Code
        CASE 
            WHEN v_NISS_CLASS_CD = 'NISS Class Code Toggle Auto' THEN 'Final NISS Class Code Toggle Auto'
            ELSE 'Final NISS Class Code Other'
        END AS NISS_CLASS_CD,
        -- Record exception indicator
        CASE 
            WHEN NISS_CLASS_CD = 'Final NISS Class Code Toggle Auto' THEN 1
            ELSE 0
        END AS REC_EXCP_IND,
        -- Record exception description class
        CASE 
            WHEN REC_EXCP_IND = 1 THEN 'Exception Class Toggle Auto'
            ELSE 'Exception Class Other'
        END AS REC_EXCP_DESC_CLASS,
        -- Concatenation of exception descriptions
        CONCAT(REC_EXCP_DESC_CLASS, ' - Additional Info') AS REC_EXCP_DESC
    FROM base_data
)

SELECT *
FROM derived_fields