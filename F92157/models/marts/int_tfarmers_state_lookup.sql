WITH farmers_state AS (
    SELECT
        FARMERS_STATE_CD,
        STATE_CODE
    FROM {{ ref('ref_tfarmers_state') }}
)
SELECT
    FARMERS_STATE_CD,
    CAST(FARMERS_STATE_CD AS INTEGER) AS IFARMERS_STATE_CD,
    STATE_CODE
FROM farmers_state;