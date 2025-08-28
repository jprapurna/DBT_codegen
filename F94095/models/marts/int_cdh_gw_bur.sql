-- Purpose: Intermediate model for CDH_GW_BUR transformations
WITH transformed_data AS (
    SELECT 
        POLICY_STATE,
        BUR,
        SOURCE_NAME,
        {{ surrogate_key(['POLICY_STATE', 'BUR']) }} AS INTEGRATION_ID
    FROM {{ ref('stg_cdh_gw_bur') }}
)
SELECT * FROM transformed_data