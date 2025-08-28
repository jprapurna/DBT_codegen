WITH lookup_data AS (
    SELECT 
        lkp_ROW_WID,
        lkp_INTEGRATION_ID,
        lkp_NEW_BUR
    FROM {{ ref('scd3_lookup') }}
)
SELECT * FROM lookup_data