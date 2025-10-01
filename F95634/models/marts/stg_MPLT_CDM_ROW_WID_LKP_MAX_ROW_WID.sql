{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('GENAI_POWER_BI_CDM', 'MPLT_CDM_ROW_WID_LKP_MAX_ROW_WID') }}