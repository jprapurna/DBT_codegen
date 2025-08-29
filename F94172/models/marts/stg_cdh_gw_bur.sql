WITH source_data AS (
    SELECT
        POLICY_STATE,
        BUR,
        {{ safe_cast('GWCDH', 'string') }} AS SOURCE_NAME
    FROM {{ source('CDH_GW_BUR', 'CDH_GW_BUR') }}
)
SELECT * FROM source_data;