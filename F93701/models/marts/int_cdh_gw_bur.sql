-- Purpose: Extracts data from the table CDH_GW_BUR using a custom SQL query.
WITH source_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    $$SOURCE_NAME_GWCDM AS SOURCE_NAME
  FROM {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}
)
SELECT * FROM source_data