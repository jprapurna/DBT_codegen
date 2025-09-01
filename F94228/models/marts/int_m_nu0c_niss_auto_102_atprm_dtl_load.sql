{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    FISC_PER_YR, 
    NAIC_CMPNY_CD, 
    NISS_CMPNY_CD, 
    ST_NM, 
    ST_CD, 
    NISS_ST_CD, 
    ST_ABBR, 
    ACCTNG_LOB, 
    CVG_TYP_CD, 
    CVG_AMT
  FROM {{ source('genai_power_bi', 'WRK_BIRP_TA_NISS_NU0C_APRM_DTL') }}
),

exptrans_step AS (
  SELECT 
    FISC_PER_YR, 
    NAIC_CMPNY_CD, 
    NISS_CMPNY_CD, 
    ST_NM, 
    ST_CD, 
    NISS_ST_CD, 
    ST_ABBR, 
    ACCTNG_LOB, 
    CVG_TYP_CD, 
    CVG_AMT
  FROM source_data
),

exp_passthru_step AS (
  SELECT 
    FISC_PER_YR, 
    NAIC_CMPNY_CD, 
    IIF(TRIM(ST_NM) = 'Unknown', '???', NISS_CMPNY_CD) AS o_NISS_CMPNY_CD, 
    ST_NM, 
    IIF(TRIM(ST_NM) = 'Unknown', '???', NISS_ST_CD) AS o_NISS_ST_CD
  FROM exptrans_step
),

lookup_rbi_ref_auto_terr_step AS (
  SELECT 
    REF_AUTO_TERR_SK, 
    END_EFF_DT, 
    CHCKSUM, 
    CR_BY_MAPNG_ID, 
    DW_CR_TMSP, 
    UPD_BY_MAPNG_ID, 
    DW_UPD_TMSP, 
    WRK_FLOW_RUN_ID, 
    NISS_TERR_CD, 
    CNTY_NM, 
    CITY_NM, 
    SRC_EFF_DT, 
    SRC_OBSLT_DT, 
    NISS_ST_CD, 
    ST_ABBRV, 
    ZIP_CD, 
    PP_COMMRCL_CD
  FROM {{ source('birp', 'RBI_REF_AUTO_TERR') }}
  WHERE END_EFF_DT = '2999-12-31'
),

exp_passthru_tgt_step AS (
  SELECT 
    v_CNT + 1 AS v_CNT, 
    v_CNT AS NISS_APRM_DETL_SK, 
    $$CLNDR_YR AS CALL_YR, 
    IIF(ISNULL(AUTO_USE_CD), '', AUTO_USE_CD) AS o_AUTO_USE_CD, 
    IIF(IN(v_NISS_TERR_CD, '???', '?'), 
        CASE 
          WHEN NISS_ST_CD = '01' THEN '029'
          WHEN NISS_ST_CD = '02' THEN '030'
          WHEN NISS_ST_CD = '03' THEN '011'
          WHEN NISS_ST_CD = '05' THEN '013'
          WHEN NISS_ST_CD = '06' THEN '164'
          WHEN NISS_ST_CD = '07' THEN '003'
          WHEN NISS_ST_CD = '09' THEN '033'
          WHEN NISS_ST_CD = '10' THEN '019'
          WHEN NISS_ST_CD = '11' THEN '005'
          WHEN NISS_ST_CD = '12' THEN '034'
          WHEN NISS_ST_CD = '13' THEN '033'
          WHEN NISS_ST_CD = '14' THEN '023'
          WHEN NISS_ST_CD = '15' THEN '017'
          WHEN NISS_ST_CD = '16' THEN '001'
          WHEN NISS_ST_CD = '17' THEN '011'
          WHEN NISS_ST_CD = '18' THEN '026'
          WHEN NISS_ST_CD = '19' THEN '014'
          WHEN NISS_ST_CD = '21' THEN '038'
          WHEN NISS_ST_CD = '22' THEN '001'
          WHEN NISS_ST_CD = '23' THEN '005'
          WHEN NISS_ST_CD = '24' THEN '029'
          WHEN NISS_ST_CD = '25' THEN '005'
          WHEN NISS_ST_CD = '26' THEN '024'
          WHEN NISS_ST_CD = '27' THEN '006'
          WHEN NISS_ST_CD = '28' THEN '018'
          WHEN NISS_ST_CD = '29' THEN '104'
          WHEN NISS_ST_CD = '30' THEN '006'
          WHEN NISS_ST_CD = '31' THEN '003'
          WHEN NISS_ST_CD = '32' THEN '024'
          WHEN NISS_ST_CD = '33' THEN '002'
          WHEN NISS_ST_CD = '34' THEN '052'
          WHEN NISS_ST_CD = '35' THEN '021'
          WHEN NISS_ST_CD = '36' THEN '006'
          WHEN NISS_ST_CD = '37' THEN '014'
          WHEN NISS_ST_CD = '39' THEN '058'
          WHEN NISS_ST_CD = '40' THEN '004'
          WHEN NISS_ST_CD = '41' THEN '002'
          WHEN NISS_ST_CD = '43' THEN '003'
          WHEN NISS_ST_CD = '44' THEN '023'
          WHEN NISS_ST_CD = '45' THEN '020'
          WHEN NISS_ST_CD = '46' THEN '033'
          WHEN NISS_ST_CD = '47' THEN '018'
          WHEN NISS_ST_CD = '48' THEN '017'
          WHEN NISS_ST_CD = '49' THEN '099'
          ELSE '???'
        END, 
        v_NISS_TERR_CD) AS o_NISS_TERR_CD
  FROM exp_passthru_step
)

SELECT * FROM exp_passthru_tgt_step