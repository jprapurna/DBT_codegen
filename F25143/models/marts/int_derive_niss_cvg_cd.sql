WITH source_data AS (
    SELECT 
        CVG_TYP_CD, CVG_AMT, BI_LMT, GA_ADDED_AT_FAULT_IND, FA2_PLCY_IND, UM_UMI_STACKING, 
        PIP_WVR_WL_IND, PIP_MED_SEC_IND, PIP_LOSS_INCOME_IND, MI_PPO_IND, COMP_DED, COLL_DED, 
        RATNG_CMPY_CD, MIS_LOB, SOURCE_IND_DERIVED
    FROM {{ ref('source_table') }}
),
derived_data AS (
    SELECT 
        TO_INTEGER(REPLACE(COLL_DED, ',', '')) AS v_COLL_DED,
        COLL_DED AS v_COLL_DED_STR,
        IIF(INSTR(COMP_DED, '/') = 0, TO_INTEGER(REPLACE(COMP_DED, ',', '')), NULL) AS v_COMP_DED,
        DECODE(PIP_WVR_WL_IND, 'Y', 1, 'N', 0, NULL) AS v_PIP_WVR_WL_IND,
        DECODE(PIP_MED_SEC_IND, 'Y', 1, 'N', 0, NULL) AS v_PIP_MED_SEC_IND,
        DECODE(PIP_LOSS_INCOME_IND, 'Y', 1, 'N', 0, NULL) AS v_PIP_LOSS_INCOME_IND,
        DECODE(MI_PPO_IND, 'Y', 1, 'N', 0, NULL) AS v_MI_PPO_IND,
        -- Complex logic for deriving coverage codes
        CASE 
            WHEN CVG_TYP_CD = 'XYZ' THEN 'Derived_Code_1'
            WHEN CVG_TYP_CD = 'ABC' THEN 'Derived_Code_2'
            ELSE 'Default_Code'
        END AS v_CVG_CD_STEP1
    FROM source_data
)
SELECT * FROM derived_data;