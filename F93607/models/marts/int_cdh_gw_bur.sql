-- Purpose: Extracts data from the table CDH_GW_BUR using a custom SQL query with schema and source name substitution

WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    SOURCE_NAME
  FROM {{ source('CDH_GWODS', 'SQ_CDH_GW_BUR') }}
)

SELECT 
  POLICY_STATE,
  BUR,
  '{{ var("SOURCE_NAME_GWCDM") }}' AS source_name
FROM source_data