-- Purpose: Splits coverage amount based on '/' and derives individual parts

WITH cvg_amount_split AS (
    SELECT
        CVG_AMT,
        REPLACECHR(0, LTRIM(RTRIM(CVG_AMT)), ',', '') AS v_CVG_AMT,
        LENGTH(REPLACECHR(0, LTRIM(RTRIM(CVG_AMT)), ',', '')) - LENGTH(REPLACECHR(0, REPLACECHR(0, LTRIM(RTRIM(CVG_AMT)), ',', ''), '/', '')) + 1 AS v_CVG_AMT_Parts,
        INSTR(REPLACECHR(0, LTRIM(RTRIM(CVG_AMT)), ',', ''), '/', 1, 1) AS v_CVG_AMT_Part1_Pos,
        INSTR(REPLACECHR(0, LTRIM(RTRIM(CVG_AMT)), ',', ''), '/', 1, 2) AS v_CVG_AMT_Part2_Pos,
        DECODE(v_CVG_AMT_Parts, 1, v_CVG_AMT, SUBSTR(v_CVG_AMT, 1, v_CVG_AMT_Part1_Pos - 1)) AS v_AMOUNT_FIELD1,
        DECODE(v_CVG_AMT_Parts, 2, SUBSTR(v_CVG_AMT, v_CVG_AMT_Part1_Pos + 1), SUBSTR(v_CVG_AMT, v_CVG_AMT_Part1_Pos + 1, v_CVG_AMT_Part2_Pos - v_CVG_AMT_Part1_Pos - 1)) AS v_AMOUNT_FIELD2,
        DECODE(v_CVG_AMT_Parts, 3, SUBSTR(v_CVG_AMT, v_CVG_AMT_Part2_Pos + 1)) AS v_AMOUNT_FIELD3
    FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
    CVG_AMT,
    v_AMOUNT_FIELD1 AS CVG_AMT_1_String,
    v_AMOUNT_FIELD2 AS CVG_AMT_2_String,
    v_AMOUNT_FIELD3 AS CVG_AMT_3_String,
    TO_DECIMAL(v_AMOUNT_FIELD1) AS CVG_AMT_1_Decimal,
    TO_DECIMAL(v_AMOUNT_FIELD2) AS CVG_AMT_2_Decimal,
    TO_DECIMAL(v_AMOUNT_FIELD3) AS CVG_AMT_3_Decimal,
    v_CVG_AMT_Parts AS CVG_AMT_NO_OF_PARTS,
    v_CVG_AMT AS SRC_CVG_AMT
FROM cvg_amount_split