-- Purpose: Fetch territory details by state, zip, and line of business
WITH territory_details AS (
    SELECT
        terr.NISS_TERR_CD,
        terr.NISS_ST_CD,
        terr.ST_ABBRV,
        terr.ZIP_CD
    FROM {{ source('power_center', 'RBI_REF_AUTO_TERR') }} AS terr
    JOIN {{ ref('farmers_state') }} AS state
    ON terr.NISS_ST_CD = state.STATE_CODE
)

SELECT * FROM territory_details