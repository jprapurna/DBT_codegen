WITH ref_tfarmers_state_snapshot AS (
    SELECT 
        FARMERS_STATE_CD,
        STATE_CODE
    FROM {{ ref('farmers_state_reference') }}
)
SELECT 
    FARMERS_STATE_CD,
    STATE_CODE
FROM ref_tfarmers_state_snapshot
