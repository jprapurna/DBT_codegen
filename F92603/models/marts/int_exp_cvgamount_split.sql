-- Purpose: Splits coverage amount based on '/' and derives individual parts

WITH cvg_amount_split AS (
  SELECT
    CVG_AMT,
    REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', '') AS v_cvg_amt,
    LENGTH(REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', '')) - LENGTH(REPLACE(REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', ''), '/', '')) + 1 AS v_cvg_amt_parts,
    INSTR(REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', ''), '/', 1, 1) AS v_cvg_amt_part1_pos,
    INSTR(REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', ''), '/', 1, 2) AS v_cvg_amt_part2_pos,
    DECODE(v_cvg_amt_parts, 1, v_cvg_amt, SUBSTR(v_cvg_amt, 1, v_cvg_amt_part1_pos - 1)) AS v_amount_field1,
    DECODE(v_cvg_amt_parts, 2, SUBSTR(v_cvg_amt, v_cvg_amt_part1_pos + 1), SUBSTR(v_cvg_amt, v_cvg_amt_part1_pos + 1, v_cvg_amt_part2_pos - v_cvg_amt_part1_pos - 1)) AS v_amount_field2,
    DECODE(v_cvg_amt_parts, 3, SUBSTR(v_cvg_amt, v_cvg_amt_part2_pos + 1)) AS v_amount_field3
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT
  CVG_AMT,
  v_amount_field1 AS cvg_amt_1_string,
  v_amount_field2 AS cvg_amt_2_string,
  v_amount_field3 AS cvg_amt_3_string,
  TO_DECIMAL(v_amount_field1) AS cvg_amt_1_decimal,
  TO_DECIMAL(v_amount_field2) AS cvg_amt_2_decimal,
  TO_DECIMAL(v_amount_field3) AS cvg_amt_3_decimal,
  v_cvg_amt_parts AS cvg_amt_no_of_parts,
  v_cvg_amt AS src_cvg_amt
FROM cvg_amount_split