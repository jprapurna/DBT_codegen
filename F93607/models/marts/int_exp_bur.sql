-- Purpose: Applies field-level transformations to map POLICY_STATE to INTEGRATION_ID and passes BUR and SOURCE_NAME unchanged

WITH transformed_data AS (
  SELECT 
    POLICY_STATE,
    BUR,
    SOURCE_NAME
  FROM {{ ref('int_cdh_gw_bur') }}
)

SELECT 
  POLICY_STATE AS integration_id,
  BUR,
  SOURCE_NAME
FROM transformed_data