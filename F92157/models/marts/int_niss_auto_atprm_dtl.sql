WITH base_data AS (
    SELECT
        ST_ABBR,
        AGE,
        GENDR,
        MRTL_STAT,
        MLT_CAR_IND,
        AUTO_USE_CD,
        SOI_TYP,
        ACCTNG_LOB,
        CVG_TYP_CD
    FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
),
derived_fields AS (
    SELECT
        ST_ABBR,
        AGE,
        GENDR,
        MRTL_STAT,
        MLT_CAR_IND,
        AUTO_USE_CD,
        SOI_TYP,
        ACCTNG_LOB,
        CVG_TYP_CD,
        {{ dbt_utils.safe_cast('AGE', 'INTEGER') }} AS IAGE,
        {{ dbt_utils.safe_cast('AUTO_USE_CD', 'STRING') }} AS AUTO_USE_CD,
        {{ derive_class_code('ST_ABBR', 'AGE', 'GENDR', 'MRTL_STAT', 'MLT_CAR_IND', 'AUTO_USE_CD', 'SOI_TYP', 'ACCTNG_LOB', 'CVG_TYP_CD') }} AS v_CLASS_CODE_TAuto,
        CASE
            WHEN AUTO_USE_CD IS NULL THEN 'UNKNOWN'
            ELSE AUTO_USE_CD
        END AS v_CLASS_CODE_TAuto_Final,
        CASE
            WHEN CVG_TYP_CD = 'MISC' THEN 'MISC_CLASS'
            ELSE 'DEFAULT_MISC'
        END AS v_CLASS_CD_Misc_Final,
        CASE
            WHEN CVG_TYP_CD = 'INDEMNITY' THEN 'INDEMNITY_CLASS'
            ELSE 'DEFAULT_INDEMNITY'
        END AS v_NISS_CLASS_CD,
        CASE
            WHEN CVG_TYP_CD IS NULL THEN 'UNKNOWN'
            ELSE CVG_TYP_CD
        END AS NISS_CLASS_CD,
        CASE
            WHEN AGE < 18 THEN 'EXCEPTION_MINOR'
            ELSE 'NO_EXCEPTION'
        END AS REC_EXCP_IND,
        CONCAT('Exception reason: ', REC_EXCP_IND) AS REC_EXCP_DESC
    FROM base_data
)
SELECT *
FROM derived_fields