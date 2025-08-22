WITH source_data AS (
    SELECT 
        POLICY_STATE, 
        BUR, 
        '{{ source_name_gwcdm() }}' AS SOURCE_NAME
    FROM {{ schema_cdh_gwods() }}.CDH_GW_BUR
)
SELECT *
FROM source_data