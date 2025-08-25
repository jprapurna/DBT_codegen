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
    niss_state_mapping.NISS_STATE_CODE,
    farmers_state_mapping.STATE_CODE,
    CASE 
        WHEN niss_state_mapping.NISS_STATE_CODE IS NULL THEN '?'
        WHEN TRIM(niss_state_mapping.NISS_STATE_CODE) = '' THEN '?'
        ELSE TRIM(niss_state_mapping.NISS_STATE_CODE)
    END AS TERR_CD
FROM niss_state_mapping
LEFT JOIN farmers_state_mapping
    ON niss_state_mapping.FARMERS_STATE_NAME = farmers_state_mapping.STATE_CODE
