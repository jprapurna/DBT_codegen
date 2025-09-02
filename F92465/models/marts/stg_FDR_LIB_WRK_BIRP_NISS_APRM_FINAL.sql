{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_FINAL') }}