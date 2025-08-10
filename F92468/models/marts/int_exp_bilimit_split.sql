-- Purpose: Splits BI limit based on '/' and converts parts to integers

WITH bi_limit_split AS (
  SELECT 
    BI_LMT,
    REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', '') AS v_BI_LMT,
    LENGTH(LTRIM(RTRIM(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', '')))) - LENGTH(REPLACECHR(0, LTRIM(RTRIM(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', ''))), '/', '')) + 1 AS v_BI_LMT_Parts,
    INSTR(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', ''), '/', 1, 1) AS v_BI_LMT_Part1_Pos,
    INSTR(REPLACECHR(0, LTRIM(RTRIM(BI_LMT)), ',', ''), '/', 1, 2) AS v_BI_LMT_Part2_Pos
  FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT 
  BI_LMT,
  DECODE(1, v_BI_LMT_Parts=1, v_BI_LMT, v_BI_LMT_Parts=2, SUBSTR(LTRIM(RTRIM(v_BI_LMT)), 1, v_BI_LMT_Part1_Pos-1), v_BI_LMT_Parts=3, SUBSTR(LTRIM(RTRIM(v_BI_LMT)), 1, v_BI_LMT_Part1_Pos-1), '0') AS v_Limit_FIELD1,
  DECODE(1, v_BI_LMT_Parts=1, '0', v_BI_LMT_Parts=2, SUBSTR(LTRIM(RTRIM(v_BI_LMT)), v_BI_LMT_Part1_Pos+1), v_BI_LMT_Parts=3, SUBSTR(LTRIM(RTRIM(v_BI_LMT)), v_BI_LMT_Part1_Pos+1, v_BI_LMT_Part2_Pos - v_BI_LMT_Part1_Pos -1), '0') AS v_Limit_FIELD2,
  DECODE(1, v_BI_LMT_Parts=1, '0', v_BI_LMT_Parts=2, '0', v_BI_LMT_Parts=3, SUBSTR(LTRIM(RTRIM(v_BI_LMT)), v_BI_LMT_Part2_Pos+1), '0') AS v_Limit_FIELD3,
  TO_INTEGER(v_Limit_FIELD1) AS BI_LMT_1_Decimal,
  TO_INTEGER(v_Limit_FIELD2) AS BI_LMT_2_Decimal,
  TO_INTEGER(v_Limit_FIELD3) AS BI_LMT_3_Decimal,
  v_BI_LMT_Parts AS BI_LMT_NO_OF_PARTS,
  v_BI_LMT AS SRC_BI_LMT
FROM bi_limit_split