-- Purpose: Staging model for CDH Gateway BUR data.
WITH source_data AS (
    SELECT 
        POLICY_STATE,
        BUR,
        SOURCE_NAME
    FROM {{ source('CDH_GWODS', 'SQ_CDH_GW_BUR') }}
)
SELECT * FROM source_data;