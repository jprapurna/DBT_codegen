-- Purpose: Extracts data from the table CDH_GW_BUR using schema and source name substitution.
SELECT 
    POLICY_STATE, 
    BUR, 
    {{ source_name_gwcdm() }} AS SOURCE_NAME
FROM {{ schema_cdh_gwods() }}.CDH_GW_BUR