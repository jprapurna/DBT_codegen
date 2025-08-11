-- Purpose: Extracts data from the CDH_GW_BUR table with SQL override using variables SCHEMA_CDH_GWODS and SOURCE_NAME_GWCDM.
WITH cdh_gw_bur AS (
    SELECT 
        POLICY_STATE, 
        BUR, 
        'GWCDH' AS source_name
    FROM 
        {{ source('IICS', 'SQ_CDH_GW_BUR') }}
)
SELECT 
    POLICY_STATE, 
    BUR, 
    source_name
FROM 
    cdh_gw_bur