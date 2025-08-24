WITH state_lookup AS (
    SELECT
        FARMERS_STATE_NAME,
        NISS_STATE_CODE
    FROM {{ ref('ff_NISS_STATE') }}
)
SELECT
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
FROM state_lookup;