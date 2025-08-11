-- Purpose: Final model for reporting or analytics on NISS_CVG_CD

WITH final_niss_cvg_cd AS (
    SELECT
        a.NISS_APRM_DETL_SK,
        a.NISS_CVG_CD,
        b.BI_LMT_1_Decimal,
        b.BI_LMT_2_Decimal,
        b.BI_LMT_3_Decimal,
        c.CVG_AMT_1_Decimal,
        c.CVG_AMT_2_Decimal,
        c.CVG_AMT_3_Decimal
    FROM {{ ref('int_upd_niss_cvg_cd') }} AS a
    JOIN {{ ref('int_exp_bilimit_split') }} AS b ON a.NISS_APRM_DETL_SK = b.NISS_APRM_DETL_SK
    JOIN {{ ref('int_exp_cvgamount_split') }} AS c ON a.NISS_APRM_DETL_SK = c.NISS_APRM_DETL_SK
)

SELECT
    NISS_APRM_DETL_SK,
    NISS_CVG_CD,
    BI_LMT_1_Decimal,
    BI_LMT_2_Decimal,
    BI_LMT_3_Decimal,
    CVG_AMT_1_Decimal,
    CVG_AMT_2_Decimal,
    CVG_AMT_3_Decimal
FROM final_niss_cvg_cd