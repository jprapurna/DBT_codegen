{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "PARAMETER_FILE" AS parameter_file -- Parameter file for CDM
    FROM {{ source('genai_power_bi', 'cdm_param') }}
)
SELECT
    parameter_file
FROM source_data