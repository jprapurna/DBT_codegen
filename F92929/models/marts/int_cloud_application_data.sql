-- Purpose: Integrate data from cloud applications like Salesforce, Microsoft Dynamics, and ServiceNow

WITH cloud_application_data AS (
  SELECT
    salesforce_field AS sf_field,
    dynamics_field AS ms_field,
    servicenow_field AS sn_field,
    COALESCE(expression_transformation(sf_field), 'default_value') AS normalized_sf_field,
    COALESCE(expression_transformation(ms_field), 'default_value') AS normalized_ms_field,
    COALESCE(expression_transformation(sn_field), 'default_value') AS normalized_sn_field
  FROM {{ source('Snowflake', 'cloud_application_data') }}
)

SELECT
  sf_field,
  ms_field,
  sn_field,
  normalized_sf_field,
  normalized_ms_field,
  normalized_sn_field
FROM cloud_application_data