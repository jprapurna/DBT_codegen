{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state,
"BUR" AS bur,
"SOURCE_NAME" AS source_name
FROM {{ source('IICS', 'Customer') }}