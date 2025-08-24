WITH ref_niss_state_cd AS (
    SELECT 
        FARMERS_STATE_NAME,
        NISS_STATE_CODE
    FROM {{ ref('ref_niss_state_cd') }}
)
SELECT 
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
FROM ref_niss_state_cd