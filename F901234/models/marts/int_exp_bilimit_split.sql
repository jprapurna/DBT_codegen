-- Purpose: Splits BI limit based on '/' and converts parts to integers

WITH bi_limit_split AS (
    SELECT
        BI_LMT,
        REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', '') AS v_BI_LMT,
        LENGTH(LTRIM(RTRIM(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', '')))) - LENGTH(REPLACECHR(0, LTRIM(RTRIM(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', ''))), '/', '')) + 1 AS v_BI_LMT_Parts,
        INSTR(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', ''), '/', 1, 1) AS v_BI_LMT_Part1_Pos,
        INSTR(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', ''), '/', 1, 2) AS v_BI_LMT_Part2_Pos,
        DECODE(v_BI_LMT_Parts, 1, v_BI_LMT, SUBSTR(v_BI_LMT, 1, v_BI_LMT_Part1_Pos - 1)) AS v_Limit_FIELD1,
        DECODE(v_BI_LMT_Parts, 2, SUBSTR(v_BI_LMT, v_BI_LMT_Part1_Pos + 1), SUBSTR(v_BI_LMT, v_BI_LMT_Part1_Pos + 1, v_BI_LMT_Part2_Pos - v_BI_LMT_Part1_Pos - 1)) AS v_Limit_FIELD2,
        DECODE(v_BI_LMT_Parts, 3, SUBSTR(v_BI_LMT, v_BI_LMT_Part2_Pos + 1)) AS v_Limit_FIELD3
    FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
    BI_LMT,
    TO_INTEGER(v_Limit_FIELD1) AS BI_LMT_1_Decimal,
    TO_INTEGER(v_Limit_FIELD2) AS BI_LMT_2_Decimal,
    TO_INTEGER(v_Limit_FIELD3) AS BI_LMT_3_Decimal,
    v_BI_LMT_Parts AS BI_LMT_NO_OF_PARTS,
    v_BI_LMT AS SRC_BI_LMT,
    REC_EXCPN_IND,
    REC_EXCPN_RSN_DESC
FROM bi_limit_split