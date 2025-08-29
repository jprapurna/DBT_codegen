{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "DUMMY_mplt_CDM_ROW_WID_lkp_MAX_ROW_WID" AS dummy_mplt_cdm_row_wid_lkp_max_row_wid -- Error: Table does not exist or not authorized
    FROM {{ source('CDM', 'LKP_MAX_ROW_WID') }}
)
SELECT
    dummy_mplt_cdm_row_wid_lkp_max_row_wid
FROM source_data