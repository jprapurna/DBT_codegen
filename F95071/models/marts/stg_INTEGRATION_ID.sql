{{ config(materialized='view') }}

SELECT
    INTEGRATION_ID AS integration_id -- Integration identifier
FROM {{ source('Snowflake_CDM', 'INTEGRATION_ID') }}