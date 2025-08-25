WITH auto_territory_data AS (
    SELECT
        NISS_TERR_CD,
        NISS_ST_CD,
        ST_ABBRV,
        ZIP_CD
    FROM {{ ref('auto_territory_reference') }}
)
SELECT *
FROM auto_territory_data