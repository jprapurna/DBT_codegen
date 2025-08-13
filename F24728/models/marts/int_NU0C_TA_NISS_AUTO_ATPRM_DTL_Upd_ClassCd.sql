-- Purpose: To derive and update class codes for Toggle Auto data based on various factors.

WITH base_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        ST_CD,
        ST_ABBR,
        ACCTNG_LOB,
        CVG_TYP_CD,
        RATNG_CMPY_CD,
        MLT_CAR_IND,
        AGE,
        CAST(AGE AS INTEGER) AS IAGE,
        GENDR,
        MRTL_STAT,
        i_AUTO_USE_CD,
        COALESCE(i_AUTO_USE_CD, '') AS AUTO_USE_CD,
        SOI_TYP,
        DECODE(ST_CD, 'LA', 'Misc_1', 'MI', 'Misc_2', 'MT', 'Misc_2', 'PA', 'Misc_2', 'FL', 'Misc_6_FL', 'Misc_5') AS v_CLASS_CD_Misc_1,
        DECODE(ST_CD, 'MI', 'Misc_2', 'MT', 'Misc_2', 'PA', 'Misc_2', 'FL', 'Misc_6_FL', 'Misc_5') AS v_CLASS_CD_Misc_2,
        CASE
            WHEN ST_CD IN ('FL', 'GA') THEN 'Misc_4'
            ELSE 'Misc_3'
        END AS v_CLASS_CD_Misc_3,
        CASE
            WHEN ST_CD IN ('FL', 'GA') THEN 'Misc_4'
            ELSE 'Misc_3'
        END AS v_CLASS_CD_Misc_4,
        DECODE(ST_CD, 'FL', 'Misc_6_FL', 'Misc_5') AS v_CLASS_CD_Misc_5,
        DECODE(ST_CD, 'FL', 'Misc_6_FL', 'Misc_5') AS v_CLASS_CD_Misc_6_FL,
        DECODE(ST_CD, 'LA', 'Misc_1', 'MI', 'Misc_2', 'MT', 'Misc_2', 'PA', 'Misc_2', 'FL', 'Misc_6_FL', 'Misc_5') AS v_CLASS_CD_Misc_Final,
        DECODE(ACCTNG_LOB, 'Indemnity', 'Indemnity_Class', 'Misc', 'Misc_Class') AS v_NISS_CLASS_CD,
        CASE
            WHEN v_NISS_CLASS_CD = 'Placeholder' THEN 'Default_Class'
            ELSE v_NISS_CLASS_CD
        END AS NISS_CLASS_CD,
        CASE
            WHEN i_REC_EXCPN_IND = 'Y' THEN 'Exception'
            ELSE 'No Exception'
        END AS REC_EXCP_IND,
        CASE
            WHEN i_REC_EXCPN_IND = 'Y' THEN 'Exception Description'
            ELSE 'No Exception Description'
        END AS REC_EXCP_DESC_CLASS,
        i_REC_EXCPN_IND,
        CASE
            WHEN i_REC_EXCPN_IND = 'Y' THEN 'Exception'
            ELSE 'No Exception'
        END AS REC_EXCPN_IND,
        REC_EXCPN_RSN_DESC_ZIP,
        CONCAT(REC_EXCPN_RSN_DESC_ZIP, ' ', REC_EXCP_DESC_CLASS) AS REC_EXCP_DESC
    FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT * FROM base_data