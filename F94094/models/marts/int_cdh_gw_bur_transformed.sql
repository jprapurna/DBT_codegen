WITH transformed_data AS (
    SELECT 
        POLICY_STATE AS INTEGRATION_ID,
        BUR,
        SOURCE_NAME
    FROM {{ ref('stg_cdh_gw_bur') }}
)
SELECT * FROM transformed_data