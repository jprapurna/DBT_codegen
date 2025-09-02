{{ config(materialized='table') }}

WITH intermediate_data AS (
    SELECT *
    FROM {{ ref('int_m_nu0c_niss_auto_117_atprm_sumry_load') }}
),

final AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY NISS_CMPNY_CD, CLNDR_YR) AS NISS_APRM_SUMRY_SK,
        NISS_CMPNY_CD,
        CLNDR_YR,
        ST_ABBR,
        NISS_ST_CD,
        ACCDNT_YR,
        NISS_CVG_CD,
        NISS_CLASS_CD,
        NISS_SUBLOB_CD,
        NISS_TYP_LOSS_CD,
        NISS_ANNL_STMNT_LOB_CD,
        CVG_EXPS_VAL,
        TTL_WRITTN_PREM_AMT,
        NISS_PD_LOSS,
        NISS_PD_ALLOC_ADJUS_EXPNS,
        NISS_OUTSTNDG_LOSS,
        NISS_NO_PD_CLMS,
        NISS_NO_OUTSTND_CLMS,
        CR_BY_MAPNG_ID,
        DW_CR_TMSP,
        UPD_BY_MAPNG_ID,
        DW_UPD_TMSP,
        WRK_FLOW_RUN_ID,
        NISS_TERR_CD
    FROM intermediate_data
)

SELECT *
FROM final
