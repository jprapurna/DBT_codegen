WITH territory_lookup AS (
    SELECT
        NISS_STATE_CODE,
        ST_ABBRV,
        ZIP_CD,
        COALESCE(NISS_TERR_CD, 'UNKNOWN') AS NISS_TERR_CD
    FROM {{ source('BIRP', 'RBI_REF_AUTO_TERR') }}
)
SELECT
    src.NISS_STATE_CODE,
    src.ST_ABBRV,
    src.ZIP_CD,
    lookup.NISS_TERR_CD
FROM {{ ref('int_NISS_STATE_LOOKUP') }} src
LEFT JOIN territory_lookup lookup
    ON src.NISS_STATE_CODE = lookup.NISS_STATE_CODE
    AND src.ST_ABBRV = lookup.ST_ABBRV
    AND src.ZIP_CD = lookup.ZIP_CD;