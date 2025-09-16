{{ config(materialized='view') }}

SELECT
    POLICY_STATE AS policy_state -- Policy state information
FROM {{ source('Snowflake_CDM', 'POLICY_STATE') }}