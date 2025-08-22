WITH transformed_data AS (
    SELECT 
        policy_state AS integration_id,
        bur,
        source_name
    FROM {{ ref('stg_cdh_gw_bur') }}
)
SELECT * FROM transformed_data