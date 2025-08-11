-- Purpose: This model derives various class codes for Toggle Auto data based on state abbreviations, age, gender, marital status, and other factors.

WITH derived_fields AS (
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
        i_AUTO_USE_CD,
        SOI_TYP,
        TO_INTEGER(AGE) AS iage,
        IIF(ISNULL(i_AUTO_USE_CD), '', i_AUTO_USE_CD) AS auto_use_cd,
        DECODE(ST_ABBR, 'FL', DECODE(ACCTNG_LOB, 'PPA', 'FL_PPA', 'OTHER', 'FL_OTHER'), 'OTHER') AS v_class_cd_indemnity,
        IIF(ST_ABBR = 'FL' AND ACCTNG_LOB = 'PPA', 'FL_PPA', 'OTHER') AS v_class_code_tauto,
        DECODE(v_class_code_tauto, 'FL_PPA', 'FL_PPA_FINAL', 'OTHER', 'OTHER_FINAL') AS v_class_code_tauto_final,
        DECODE(ST_ABBR, 'FL', 'FL_SECONDARY', 'OTHER') AS v_class_code_secondary,
        DECODE(ST_ABBR, 'FL', 'FL_MISC_1', 'OTHER') AS v_class_cd_misc_1,
        DECODE(ST_ABBR, 'FL', 'FL_MISC_2', 'OTHER') AS v_class_cd_misc_2,
        DECODE(ST_ABBR, 'FL', 'FL_MISC_3', 'OTHER') AS v_class_cd_misc_3,
        DECODE(ST_ABBR, 'FL', 'FL_MISC_4', 'OTHER') AS v_class_cd_misc_4,
        DECODE(ST_ABBR, 'FL', 'FL_MISC_5', 'OTHER') AS v_class_cd_misc_5,
        DECODE(ST_ABBR, 'FL', 'FL_MISC_6', 'OTHER') AS v_class_cd_misc_6_fl,
        DECODE(v_class_cd_misc_6_fl, 'FL_MISC_6', 'FL_MISC_FINAL', 'OTHER') AS v_class_cd_misc_final,
        DECODE(ST_ABBR, 'FL', 'FL_NISS', 'OTHER') AS v_niss_class_cd,
        IIF(v_niss_class_cd = 'FL_NISS', 'FL_NISS_FINAL', 'OTHER_FINAL') AS niss_class_cd,
        IIF(v_niss_class_cd = 'FL_NISS', 1, 0) AS rec_excp_ind,
        IIF(v_niss_class_cd = 'FL_NISS', 'EXCEPTION_FL', 'EXCEPTION_OTHER') AS rec_excp_desc_class,
        IIF(v_niss_class_cd = 'FL_NISS', 1, 0) AS rec_excpn_ind,
        CONCAT('ZIP_EXCEPTION_', rec_excp_desc_class) AS rec_excp_desc
    FROM
        {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
    NISS_APRM_DETL_SK,
    niss_class_cd,
    rec_excpn_ind,
    rec_excp_desc
FROM
    derived_fields