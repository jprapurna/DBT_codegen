{{ config(materialized='table') }}

WITH niss_state_mapping AS (
    SELECT 
        FARMERS_STATE_NAME,
        NISS_STATE_CODE
    FROM {{ ref('int_ref_niss_state_cd') }}
),
farmers_state_mapping AS (
    SELECT 
        FARMERS_STATE_CD,
        STATE_CODE
    FROM {{ ref('int_ref_tfarmers_state') }}
)
SELECT 
    {{ dbt_utils.surrogate_key(['FARMERS_STATE_NAME', 'FARMERS_STATE_CD']) }} AS unique_id,
    niss_state_mapping.NISS_STATE_CODE,
    farmers_state_mapping.STATE_CODE,
    DECODE(1, 
        ISNULL(niss_state_mapping.NISS_STATE_CODE), '?', 
        IS_SPACES(niss_state_mapping.NISS_STATE_CODE), '?', 
        LTRIM(RTRIM(niss_state_mapping.NISS_STATE_CODE))
    ) AS TERR_CD
FROM niss_state_mapping
LEFT JOIN farmers_state_mapping
ON niss_state_mapping.FARMERS_STATE_NAME = farmers_state_mapping.STATE_CODE