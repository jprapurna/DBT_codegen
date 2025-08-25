WITH farmers_state_data AS (
    SELECT
        FARMERS_STATE_CD,
        STATE_CODE
    FROM {{ ref('farmers_state_reference') }}
)
SELECT *
FROM farmers_state_data