-- Purpose: Lookup transformation to derive ST_ABBR using FARMERS_STATE_CD as input
WITH lookup_cte AS (
    SELECT 
        FARMERS_STATE_CD,
        STATE_CODE
    FROM {{ source('FDR', 'REF_TFARMERS_STATE') }}
    WHERE FARMERS_STATE_CD = i_FARMERS_STATE_CD
)
SELECT 
    FARMERS_STATE_CD,
    STATE_CODE
FROM lookup_cte