-- Purpose: Splits BI limit based on '/' and converts parts to integers

WITH bi_limit_split AS (
  SELECT
    BI_LMT,
    REPLACE(LTRIM(RTRIM(BI_LMT)), ',', '') AS v_bi_lmt,
    LENGTH(LTRIM(RTRIM(REPLACE(LTRIM(RTRIM(BI_LMT)), ',', '')))) - LENGTH(REPLACE(REPLACE(LTRIM(RTRIM(BI_LMT)), ',', ''), '/', '')) + 1 AS v_bi_lmt_parts,
    INSTR(REPLACE(LTRIM(RTRIM(BI_LMT)), ',', ''), '/', 1, 1) AS v_bi_lmt_part1_pos,
    INSTR(REPLACE(LTRIM(RTRIM(BI_LMT)), ',', ''), '/', 1, 2) AS v_bi_lmt_part2_pos,
    DECODE(v_bi_lmt_parts, 1, v_bi_lmt, SUBSTR(v_bi_lmt, 1, v_bi_lmt_part1_pos - 1)) AS v_limit_field1,
    DECODE(v_bi_lmt_parts, 2, SUBSTR(v_bi_lmt, v_bi_lmt_part1_pos + 1), SUBSTR(v_bi_lmt, v_bi_lmt_part1_pos + 1, v_bi_lmt_part2_pos - v_bi_lmt_part1_pos - 1)) AS v_limit_field2,
    DECODE(v_bi_lmt_parts, 3, SUBSTR(v_bi_lmt, v_bi_lmt_part2_pos + 1)) AS v_limit_field3
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
  BI_LMT,
  TO_INTEGER(v_limit_field1) AS bi_lmt_1_decimal,
  TO_INTEGER(v_limit_field2) AS bi_lmt_2_decimal,
  TO_INTEGER(v_limit_field3) AS bi_lmt_3_decimal,
  v_bi_lmt_parts AS bi_lmt_no_of_parts,
  v_bi_lmt AS src_bi_lmt,
  REC_EXCPN_IND,
  REC_EXCPN_RSN_DESC
FROM bi_limit_split