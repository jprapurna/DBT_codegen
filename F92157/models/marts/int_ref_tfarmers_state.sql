WITH ref_tfarmers_state_snapshot AS (
    SELECT 
        FARMERS_STATE_CD,
        STATE_CODE
    FROM {{ ref('ref_tfarmers_state_snapshot') }}
)
SELECT 
    FARMERS_STATE_CD,
    STATE_CODE
FROM ref_tfarmers_state_snapshot