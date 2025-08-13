-- Purpose: Update strategy and expression transformations for NISS class code determination.

WITH base_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        NISS_CLASS_CD,
        REC_EXCP_IND,
        REC_EXCP_DESC,
        COALESCE(I_AUTO_USE_CD, '') AS AUTO_USE_CD,
        CAST(AGE AS INTEGER) AS IAGE,
        CAST(MILES_TO_WRK AS INTEGER) AS IMILES_TO_WRK,
        -- Derived fields using DECODE and IIF logic
        DECODE(ST_ABBR, 'FL', 'Indemnity_FL', 'PA', 'Indemnity_PA', 'Default') AS v_CLASS_CD_Indemnity,
        CASE
            WHEN ST_ABBR = 'FL' THEN 'Auto_1A_FL'
            WHEN ST_ABBR IN ('MI', 'MT') THEN 'Auto_4_MI_MT'
            ELSE 'Auto_1_Default'
        END AS v_CLASS_CD_Auto_1,
        CASE
            WHEN ST_ABBR NOT IN ('FL', 'LA') THEN 'Auto_2_Exclude_FL_LA'
            ELSE 'Auto_2_Default'
        END AS v_CLASS_CD_Auto_2,
        CASE
            WHEN ST_ABBR NOT IN ('FL', 'LA', 'PA') THEN 'Auto_3_Exclude_FL_LA_PA'
            ELSE 'Auto_3_Default'
        END AS v_CLASS_CD_Auto_3,
        DECODE(ST_ABBR, 'LA', 'Auto_5_LA', 'Default') AS v_CLASS_CD_Auto_5,
        DECODE(ST_ABBR, 'PA', 'Auto_6_PA', 'Default') AS v_CLASS_CD_Auto_6
    FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
    *,
    CASE
        WHEN IAGE = 18 AND RT_CLS IN ('M6', '6M', 'F6', '6F', 'M8', 'F8', 'N6', 'G6', 'N8', 'G8', '9', '3') AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'Y' THEN '8074'
        WHEN IAGE = 18 AND RT_CLS IN ('M6', '6M', 'F6', '6F', 'M8', 'F8', 'N6', 'G6', 'N8', 'G8', '9', '3') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'N' THEN '8035'
        WHEN IAGE = 18 AND RT_CLS IN ('M6', '6M', 'F6', '6F', 'M8', 'F8', 'N6', 'G6', 'N8', 'G8', '9', '3') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'Y' THEN '8075'
        WHEN IAGE = 18 AND RT_CLS IN ('M6', '6M', 'F6', '6F', 'M8', 'F8', 'N6', 'G6', 'N8', 'G8', '9', '3') AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'N' THEN '8036'
        WHEN IAGE = 18 AND RT_CLS IN ('M6', '6M', 'F6', '6F', 'M8', 'F8', 'N6', 'G6', 'N8', 'G8', '9', '3') AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'Y' THEN '8076'
        WHEN IAGE = 18 AND RT_CLS IN ('M6', '6M', 'F6', '6F', 'M8', 'F8', 'N6', 'G6', 'N8', 'G8', '9', '3') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'N' THEN '8037'
        WHEN IAGE = 18 AND RT_CLS IN ('M6', '6M', 'F6', '6F', 'M8', 'F8', 'N6', 'G6', 'N8', 'G8', '9', '3') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'Y' THEN '8077'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'M5', 'F2', '2F', 'F5', 'N2', 'G2', '5M', '5F') AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'N' THEN '8134'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'M5', 'F2', '2F', 'F5', 'N2', 'G2', '5M', '5F') AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'Y' THEN '8174'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'F2', '2F', 'N2', 'G2') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'N' THEN '8135'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'F2', '2F', 'N2', 'G2') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'Y' THEN '8175'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'M5', 'F2', '2F', 'F5', 'N2', 'G2', '5M', '5F') AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'N' THEN '8136'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'M5', 'F2', '2F', 'F5', 'N2', 'G2', '5M', '5F') AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'Y' THEN '8176'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'F2', '2F', 'N2', 'G2') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'N' THEN '8137'
        WHEN IAGE = 18 AND RT_CLS IN ('M2', '2M', 'F2', '2F', 'N2', 'G2') AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'Y' AND DRVR_TRNG_IND = 'Y' THEN '8177'
        WHEN IAGE = 18 AND MRTL_STAT = 'M' AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'N' THEN '8934'
        WHEN IAGE = 18 AND MRTL_STAT = 'M' AND AUTO_USE_CD IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'Y' THEN '8974'
        WHEN IAGE = 18 AND MRTL_STAT = 'M' AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'N' THEN '8935'
        WHEN IAGE = 18 AND MRTL_STAT = 'M' AND AUTO_USE_CD NOT IN ('PLS', 'STG', '#', '', 'FRM') AND GOOD_STDNT_IND = 'N' AND DRVR_TRNG_IND = 'Y' THEN '8975'
        ELSE NULL
    END AS CLASS_CD
FROM base_data;