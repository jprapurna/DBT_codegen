{{ config(materialized='view') }}

SELECT
    "MPLT_CDM_ROW_WID_LKP_MAX_ROW_WID".*
FROM {{ source('genai_power_bi', 'mplt_cdm_row_wid_lkp_max_row_wid') }}