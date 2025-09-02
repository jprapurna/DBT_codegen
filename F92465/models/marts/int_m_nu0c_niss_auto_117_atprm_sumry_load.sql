{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
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
        SUM(CVG_EXPS_VAL) AS CVG_EXPS_VAL,
        SUM(TTL_WRITTN_PREM_AMT) AS TTL_WRITTN_PREM_AMT,
        NISS_PD_LOSS,
        NISS_PD_ALLOC_ADJUS_EXPNS,
        NISS_OUTSTNDG_LOSS,
        NISS_NO_PD_CLMS,
        NISS_NO_OUTSTND_CLMS,
        NISS_TERR_CD
    FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_FINAL') }}
    GROUP BY
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
        NISS_PD_LOSS,
        NISS_PD_ALLOC_ADJUS_EXPNS,
        NISS_OUTSTNDG_LOSS,
        NISS_NO_PD_CLMS,
        NISS_NO_OUTSTND_CLMS,
        NISS_TERR_CD
),

EXP_Passthru AS (
    SELECT * FROM source_data
),

EXP_Pass_Tgt AS (
    SELECT * FROM EXP_Passthru
),

-- 👇 expand the macro inline so it’s a valid CTE
audit_data AS (
    {{ mplt_abc_mapping_audit('m_NU0C_NISS_AUTO_117_ATPRM_SUMRY_Load', 'POWER_CENTER', 'Workflow_ABC') }}
),

final AS (
    SELECT
        t.*,
        a.CR_BY_MAPNG_ID,
        a.DW_CR_TMSP,
        a.UPD_BY_MAPNG_ID,
        a.DW_UPD_TMSP,
        a.WRK_FLOW_RUN_ID
    FROM EXP_Pass_Tgt t
    LEFT JOIN audit_data a ON TRUE
)

SELECT * FROM final