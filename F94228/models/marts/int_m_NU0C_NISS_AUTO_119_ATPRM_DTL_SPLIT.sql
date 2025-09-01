{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * FROM {{ source('flat_file', 'time_zone_state.csv') }}
),

-- Node: EXP_GenErrReason
exp_generrreason AS (
  SELECT
    *,
    INSTR(i_REC_DROP_RSN_DESC, ';', 1, 1) AS v_REC_DROP_RSN_DESC_POS1,
    INSTR(i_REC_DROP_RSN_DESC, ';', 1, 2) AS v_REC_DROP_RSN_DESC_POS2,
    INSTR(i_REC_DROP_RSN_DESC, ';', 1, 3) AS v_REC_DROP_RSN_DESC_POS3,
    4 AS v_REC_DROP_RSN_DESC_COUNT,
    LTRIM(RTRIM(SUBSTRING(i_REC_DROP_RSN_DESC, 1, v_REC_DROP_RSN_DESC_POS1 - 1))) AS v_REC_DROP_RSN_DESC1,
    LTRIM(RTRIM(SUBSTRING(i_REC_DROP_RSN_DESC, v_REC_DROP_RSN_DESC_POS1 + 1, v_REC_DROP_RSN_DESC_POS2 - v_REC_DROP_RSN_DESC_POS1 - 1))) AS v_REC_DROP_RSN_DESC2,
    LTRIM(RTRIM(SUBSTRING(i_REC_DROP_RSN_DESC, v_REC_DROP_RSN_DESC_POS2 + 1, v_REC_DROP_RSN_DESC_POS3 - v_REC_DROP_RSN_DESC_POS2 - 1))) AS v_REC_DROP_RSN_DESC3,
    LTRIM(RTRIM(SUBSTRING(i_REC_DROP_RSN_DESC, v_REC_DROP_RSN_DESC_POS3 + 1))) AS v_REC_DROP_RSN_DESC4,
    SUBSTRING(LTRIM(RTRIM(i_REC_DROP_RSN_DESC)), 1, 3) AS REC_DROP_RSN_DESC
  FROM source_data
),

-- Node: EXP_PASS_DETL
exp_pass_detl AS (
  SELECT
    *,
    SUBSTRING(LTRIM(RTRIM(CLNDR_YR)), 3, 2) AS o_CLNDR_YR,
    SUBSTRING(LTRIM(RTRIM(CALL_YR)), 3, 2) AS o_CALL_YR,
    'FF_FIO_TRIP_DTL_RPT_' || ST_ABBR || '_' || v_file_year || '.csv' AS filename_DTL
  FROM exp_generrreason
),

-- Node: Router
router AS (
  SELECT
    *,
    CASE 
      WHEN ST_ABBR = 'CA' THEN 'ST_ABBR1'
      WHEN ST_ABBR = 'TX' THEN 'ST_ABBR3'
      WHEN ST_ABBR NOT IN ('CA', 'TX') THEN 'ST_ABBR4'
      ELSE 'ST_ABBR2'
    END AS router_group
  FROM exp_pass_detl
),

-- Node: NON_CA_TX
non_ca_tx AS (
  SELECT
    *,
    IIF(ISNULL(TimeZone4), 'UNKNOWN', TimeZone4) AS O_TIMEZONE4
  FROM router
),

-- Node: SRT_TIMEZONE
srt_timezone AS (
  SELECT
    *
  FROM non_ca_tx
  ORDER BY o_CLNDR_YR4 ASC, o_CALL_YR4 ASC, O_TIMEZONE4 ASC
),

-- Node: EXP_Passthrough
exp_passthrough AS (
  SELECT
    *,
    IIF(V_PREV_TIMEZONE = V_CURR_TIMEZONE, 'N', 'Y') AS V_TIMEZONE_IND,
    IIF(ISNULL(TIMEZONE4), 'NU0C_NISS_AUTO_UNKNOWN_' || V_FILE_YEAR || '_AutoPrem_Detail_.csv', 'NU0C_NISS_AUTO_' || TIMEZONE4 || '_' || V_FILE_YEAR || '_AutoPrem_Detail_.csv') AS FILE_NAME
  FROM srt_timezone
),

-- Node: TCTRANS
tctrans AS (
  SELECT
    *,
    CASE 
      WHEN O_TIMEZONE_IND = 'Y' THEN TC_COMMIT_BEFORE
      ELSE TC_CONTINUE_TRANSACTION
    END AS transaction_control
  FROM exp_passthrough
),

-- Node: SRT_CA
srt_ca AS (
  SELECT
    *
  FROM router
  WHERE router_group = 'ST_ABBR1'
  ORDER BY o_CLNDR_YR1 ASC, o_CALL_YR1 ASC, NAIC_CMPNY_CD1 ASC, NISS_CMPNY_CD1 ASC, ST_NM1 ASC, ST_CD1 ASC, NISS_ST_CD1 ASC, ST_ABBR1 ASC, ACCTNG_LOB1 ASC, CVG_TYP_CD1 ASC
),

-- Node: EXP_CA_STATE
exp_ca_state AS (
  SELECT
    *
  FROM srt_ca
),

-- Node: TCTRANS2
tctrans2 AS (
  SELECT
    *,
    CASE 
      WHEN O_CMPY_CD_IND = 'Y' THEN TC_COMMIT_BEFORE
      ELSE TC_CONTINUE_TRANSACTION
    END AS transaction_control
  FROM exp_ca_state
),

-- Node: SRT_TX
srt_tx AS (
  SELECT
    *
  FROM router
  WHERE router_group = 'ST_ABBR3'
  ORDER BY o_CLNDR_YR3 ASC, o_CALL_YR3 ASC, NAIC_CMPNY_CD3 ASC, NISS_CMPNY_CD3 ASC, ST_NM3 ASC, ST_CD3 ASC, NISS_ST_CD3 ASC, ST_ABBR3 ASC, ACCTNG_LOB3 ASC, CVG_TYP_CD3 ASC
),

-- Node: EXP_TX_STATE
exp_tx_state AS (
  SELECT
    *
  FROM srt_tx
),

-- Node: TCTRANS1
tctrans1 AS (
  SELECT
    *,
    CASE 
      WHEN O_CMPY_CD_IND = 'Y' THEN TC_COMMIT_BEFORE
      ELSE TC_CONTINUE_TRANSACTION
    END AS transaction_control
  FROM exp_tx_state
)

SELECT * FROM tctrans1