{{ config(materialized='view') }}

SELECT
    POLICY_STATE AS policy_state,  -- Policy state column
    BUR AS bur,                    -- BUR column
    SOURCE_NAME AS source_name     -- Source name column
FROM {{ source('GENAI_POWER_BI_CDM', 'SQ_CDH_GW_BUR') }}