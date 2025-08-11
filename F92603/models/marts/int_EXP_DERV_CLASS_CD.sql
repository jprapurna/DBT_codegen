-- Purpose: This model derives various class codes for Toggle Auto data based on state abbreviations, age, gender, marital status, and other factors.

WITH derived_class_codes AS (
    SELECT
        NISS_APRM_DETL_SK,
        ST_CD,
        ST_ABBR,
        ACCTNG_LOB,
        CVG_TYP_CD,
        RATNG_CMPY_CD,
        MLT_CAR_IND,
        AGE,
        GENDR,
        MRTL_STAT,
        COALESCE(i_AUTO_USE_CD, '') AS AUTO_USE_CD,
        TO_INTEGER(AGE) AS IAGE,
        
        DECODE(
            ST_ABBR || ACCTNG_LOB,
            'NY' || 'LOB1', 'Indemnity_Class_1',
            'NJ' || 'LOB2', 'Indemnity_Class_2',
            'Default_Class'
        ) AS v_CLASS_CD_Indemnity,
        
        CASE
            WHEN ST_ABBR = 'NY' AND AGE < 25 THEN 'Class_A'
            WHEN ST_ABBR = 'NJ' AND GENDR = 'M' THEN 'Class_B'
            ELSE 'Class_Default'
        END AS v_CLASS_CODE_TAuto,
        
        DECODE(
            v_CLASS_CODE_TAuto,
            'Class_A', 'Final_Class_A',
            'Class_B', 'Final_Class_B',
            'Final_Class_Default'
        ) AS v_CLASS_CODE_TAuto_Final,
        
        DECODE(
            ST_ABBR,
            'NY', 'Secondary_Class_NY',
            'NJ', 'Secondary_Class_NJ',
            'Secondary_Class_Default'
        ) AS v_CLASS_CODE_Secondary,
        
        DECODE(
            ST_ABBR,
            'NY', 'Misc_Class_1',
            'NJ', 'Misc_Class_2',
            'Misc_Class_Default'
        ) AS v_CLASS_CD_Misc_1,
        
        DECODE(
            ST_ABBR,
            'NY', 'Misc_Class_Final_NY',
            'NJ', 'Misc_Class_Final_NJ',
            'Misc_Class_Final_Default'
        ) AS v_CLASS_CD_Misc_Final,
        
        DECODE(
            ST_ABBR,
            'NY', 'NISS_Class_NY',
            'NJ', 'NISS_Class_NJ',
            'NISS_Class_Default'
        ) AS v_NISS_CLASS_CD,
        
        CASE
            WHEN v_NISS_CLASS_CD = 'NISS_Class_NY' THEN 'Final_NISS_Class_NY'
            ELSE 'Final_NISS_Class_Default'
        END AS NISS_CLASS_CD,
        
        CASE
            WHEN AGE < 18 THEN 'Exception_Youth'
            ELSE 'No_Exception'
        END AS REC_EXCP_IND,
        
        CASE
            WHEN REC_EXCP_IND = 'Exception_Youth' THEN 'Youth_Exception_Class'
            ELSE 'No_Exception_Class'
        END AS REC_EXCP_DESC_CLASS,
        
        CASE
            WHEN REC_EXCP_IND = 'Exception_Youth' THEN 'Exception_Youth'
            ELSE 'No_Exception'
        END AS REC_EXCPN_IND,
        
        CONCAT('Exception_Reason_', ST_ABBR, '_', v_CLASS_CODE_TAuto_Final) AS REC_EXCP_DESC
    FROM {{ ref('stg_WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT * FROM derived_class_codes