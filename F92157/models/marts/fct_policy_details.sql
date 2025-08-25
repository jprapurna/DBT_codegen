{{ config(materialized='table') }}

WITH policy_details AS (
    SELECT
        n.NISS_STATE_CODE,
        t.STATE_CODE,
        -- t.ST_ABBRV,
        tr.NISS_TERR_CD
    FROM {{ ref('int_niss_state_lookup') }} n
    JOIN {{ ref('int_tfarmers_state_lookup') }} t
        ON n.FARMERS_STATE_NAME = t.STATE_CODE
    JOIN {{ ref('int_niss_territory_lookup') }} tr
        ON n.NISS_STATE_CODE = tr.NISS_ST_CD
)
SELECT *
FROM policy_details