-- Purpose: Represents the source data from CDH_GW_BUR with custom SQL query.
SELECT 
    POLICY_STATE,
    BUR,
    'GWCDH' AS SOURCE_NAME
FROM {{ source('CDH_GW_BUR', 'SQ_CDH_GW_BUR') }}