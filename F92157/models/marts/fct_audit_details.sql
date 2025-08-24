{{ config(materialized='table') }}
SELECT
    WRK_FLOW_RUN_ID,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP
FROM {{ ref('int_audit_lookup') }}