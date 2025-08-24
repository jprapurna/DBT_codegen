WITH territory_lookup AS (
    SELECT
        NISS_ST_CD,
        ST_ABBRV,
        ZIP_CD,
        NISS_TERR_CD
    FROM {{ source('BIRP', 'RBI_REF_AUTO_TERR') }}
)
SELECT
    NISS_ST_CD,
    ST_ABBRV,
    ZIP_CD,
    NISS_TERR_CD,
    CASE
        WHEN ZIP_CD IS NULL OR ZIP_CD = '' THEN '00000'
        ELSE LTRIM(RTRIM(ZIP_CD))
    END AS GRGNG_ZIP_5
FROM territory_lookup;