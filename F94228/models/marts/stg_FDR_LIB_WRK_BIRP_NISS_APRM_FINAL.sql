{{ config(materialized='view') }}

SELECT
    -- No columns available for this table
FROM {{ source('genai_power_bi', 'FDR_LIB_WRK_BIRP_NISS_APRM_FINAL') }}