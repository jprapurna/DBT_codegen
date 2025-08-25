WITH rbi_ref_auto_terr AS (
    SELECT *
    FROM {{ ref('rbi_ref_auto_terr') }}
)
SELECT
    NISS_ST_CD,
    ST_ABBRV,
    ZIP_CD,
    PP_COMMRCL_CD,
    NISS_TERR_CD
FROM rbi_ref_auto_terr;