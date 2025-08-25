WITH ref_tfarmers_state AS (
    SELECT *
    FROM {{ ref('ref_tfarmers_state') }}
)
SELECT
    FARMERS_STATE_CD,
    STATE_CODE
FROM ref_tfarmers_state;